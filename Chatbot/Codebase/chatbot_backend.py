import os
import asyncio
from openai import AsyncOpenAI
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from dotenv import load_dotenv
from tavily import Client as TavilyClient
from langchain.memory import ConversationBufferMemory
import google.generativeai as genai
from sklearn.metrics.pairwise import cosine_similarity
from sentence_transformers import SentenceTransformer
import concurrent.futures

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
        "top_p": 0.9,
        "top_k": 40,
        "max_output_tokens": 4096,
        "response_mime_type": "text/plain",
    }
    
    gemini_model = genai.GenerativeModel(
        model_name="gemini-1.5-flash",
        generation_config=generation_config,
    )
    
    memory = ConversationBufferMemory(return_messages=True)
    
    return openai_client, tavily_client, memory, gemini_model

def create_vector_db():
    try:
        script_dir = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(script_dir, "text_file_db.txt")
        
        with open(file_path, "r", encoding="utf-8") as file:
            text = file.read()
        print("File read successfully")
    except UnicodeDecodeError as e:
        print(f"UnicodeDecodeError: {e}")
        return None
    except Exception as e:
        print(f"Error reading file: {e}")
        return None
    
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
    chunks = text_splitter.split_text(text)
    
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    vector_store = FAISS.from_texts(chunks, embeddings)
    return vector_store

async def retrieve_context(query, vector_store, top_k=5):
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
                    {"role": "system", "content": "You are a helpful assistant that provides information about Sri Lankan Elections 2024."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.5,
                top_p=0.7,
                max_tokens=2048
            )
            return completion.choices[0].message.content
        except AttributeError:
            return completion
        except Exception as e:
            print(f"Error in get_openai_response: {e}")
            return "An error occurred while processing your request. Try again later."
    
    async def get_gemini_response(prompt):
        loop = asyncio.get_event_loop()
        chat_session = gemini_model.start_chat()
        response = await loop.run_in_executor(None, chat_session.send_message, prompt)
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

    Instructions:
    If the Question is related to elections and sri lanka politics:
    - Use the provided Context and Additional Context to inform your response.
    Otherwise:
    - Start the response with a "NO"
    - If the Question is not about elections and sri lanka politics, respond that you only answer questions about elections and cannot assist with other topics.
    - Also don't make use of the context and additional context if the question is not related to elections and sri lanka politics.

    {context}

    Answer:
    """

    return await get_openai_response(full_prompt)




if __name__ == "__main__":
    import asyncio
    
    async def main():
        openai_client, tavily_client, memory, gemini_model = initialize_clients()
        vector_store = create_vector_db()
        if vector_store is None:
            print("Failed to create vector store.")
            return
        prompt = "When is the next election in Sri Lanka?"
        response = await generate_response(prompt, openai_client, tavily_client, vector_store, memory, 1, gemini_model)
        print(response)
    
    asyncio.run(main())