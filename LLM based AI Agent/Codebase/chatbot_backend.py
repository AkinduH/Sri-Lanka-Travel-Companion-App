import os
import asyncio
from openai import AsyncOpenAI
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from dotenv import load_dotenv
from tavily import TavilyClient
from langchain.memory import ConversationBufferMemory
import google.generativeai as genai
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
import time

load_dotenv()

# Initialize SentenceTransformer for similarity
similarity_model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')

def initialize_clients():
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        raise ValueError("OPENAI_API_KEY is not set in the environment variables.")
    openai_client = AsyncOpenAI(
        base_url="https://integrate.api.nvidia.com/v1",
        api_key=openai_api_key
    )
    
    tavily_api_key = os.getenv("TAVILY_API_KEY")
    if not tavily_api_key:
        raise ValueError("TAVILY_API_KEY is not set in the environment variables.")
    tavily_client = TavilyClient(tavily_api_key)
    
    gemini_api_key = os.getenv("GEMINI_API_KEY")
    if not gemini_api_key:
        raise ValueError("GEMINI_API_KEY is not set in the environment variables.")
    genai.configure(api_key=gemini_api_key)
    
    generation_config = {
        "temperature": 0.7,
        "top_p": 1.0,
        "top_k": 40,
        "max_output_tokens": 2048,
    }
    
    gemini_model = genai.GenerativeModel(
        model_name="gemini-1.5-flash",
        generation_config=generation_config,
    )
    
    memory = ConversationBufferMemory(return_messages=True)
    
    return openai_client, tavily_client, memory, gemini_model

async def retrieve_context(query, vector_store, top_k=10):
    results = vector_store.similarity_search_with_score(query, k=top_k)
    weighted_context = ""
    for doc, score in results:
        weighted_context += f"{doc.page_content} (relevance: {score})\n\n"
    return weighted_context

def compute_similarity(text1, text2):
    embeddings = similarity_model.encode([text1, text2])
    similarity = cosine_similarity([embeddings[0]], [embeddings[1]])[0][0]
    return similarity

async def generate_response(prompt, openai_client, tavily_client, vector_store, memory, type, gemini_model):

    async def get_openai_response(prompt):
        try:
            completion = await openai_client.chat.completions.create(
                model="meta/llama-3.1-405b-instruct",
                messages=[
                    {"role": "system", "content": "You are a helpful assistant and a travel guide who is very knowledgeable about Sri Lanka and its culture, history, and tourism facilities."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.5,
                top_p=0.7,
                max_tokens=1024
            )
            return completion.choices[0].message.content
        except AttributeError:
            return completion
        except Exception as e:
            print(f"Error in get_openai_response: {e}")
            return "An error occurred while processing your request. Try again later."
    
    async def get_gemini_response(prompt):
        chat_session = gemini_model.start_chat()
        final_prompt = f""" 
        "role": "system", "content": "You are a helpful assistant and a travel guide who is very knowledgeable about Sri Lanka and its culture, history, and tourism facilities.
        "role": "user", "content": {prompt}"""
        response = chat_session.send_message(final_prompt)
        return response.text
    
    context = await retrieve_context(prompt, vector_store)    

    history = memory.load_memory_variables({})

    history_context = "\n".join([f"{m.type}: {m.content}" for m in history.get("history", [])])
    print(history_context)
    context = f"Conversation History:\n{history_context}\n\nContext: {context}\n\n"
    try:
        tavily_context = tavily_client.search(query=prompt)
        context += f"Additional Context: {tavily_context}\n\n"
    except Exception as e:
        print(f"Error fetching Tavily context: {e}")
        context += "Additional Context: No additional context available.\n\n"

    full_prompt = f"""
    Question: {prompt}

    {context}

    Instructions:
    Make sure to use the provided Context and Additional Context to make your response and use exactly what asking in the question.
    The details use recieve from context and additional context are accurate don't show any doubts in your response.
    Give the response in a friendly and engaging tone.
    If there are different categories in the context, give the response in a way that the user can understand easily.
    
    Answer:
    """
    final_response = await get_gemini_response(full_prompt)
    memory.save_context({"input": prompt}, {"output": final_response})

    return final_response

if __name__ == "__main__":
    import asyncio
    
    async def main():
        openai_client, tavily_client, memory, gemini_model = initialize_clients()
        
        embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
        
        # Change the path to the correct location of the vector stores
        script_dir = os.path.dirname(os.path.realpath(__file__))
        vector_store_path = os.path.join(script_dir, "..", "Vector DBs", "Tour_guides_and_agents_vector_store")
        # vector_store_path = os.path.join(script_dir, "..", "Vector DBs", "attractions_vector_store")
        # vector_store_path = os.path.join(script_dir, "..", "Vector DBs", "Tourist_shops_vector_store")
        
        if not os.path.exists(vector_store_path):
            raise FileNotFoundError(f"Vector store not found at {vector_store_path}. Please ensure it has been created.")
        
        vector_store = FAISS.load_local(vector_store_path, embeddings, allow_dangerous_deserialization=True)
        
        while True:
            prompt = input("You: ")
            if prompt.lower() in ["exit", "quit"]:
                print("Ending the chat. Goodbye!")
                break
            
            print("---------------------------------------------------------------------------------------------------")
            print("User Prompt: ", prompt)
            start_time = time.time()
            response = await generate_response(prompt, openai_client, tavily_client, vector_store, memory, 1, gemini_model)
            print("Chatbot Response: ", response)

            end_time = time.time()
            response_time = end_time - start_time
            print(f"Response Time: {response_time:.2f} seconds")
            print("---------------------------------------------------------------------------------------------------")
    
    asyncio.run(main())