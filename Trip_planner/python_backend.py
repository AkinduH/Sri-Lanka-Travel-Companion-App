from flask import Flask, request, jsonify
import google.generativeai as genai
from flask_cors import CORS
from dotenv import load_dotenv
import os
import re
from places import Places
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from itertools import combinations, permutations
from langchain_community.vectorstores import FAISS
from langchain_huggingface import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from tavily import TavilyClient
import ast
from openai import OpenAI
from langchain.memory import ConversationBufferMemory
import dill

load_dotenv()

app = Flask(__name__)

# Configure CORS
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# Create vector databases 
def create_vector_db():
    try:
        script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
        file_path = os.path.join(script_dir, "trip_planner_team_9th_dimension", "LLM based AI Agent", "RAG_Documents", "Combined_Resourses", "Places_to_stay","combined_star_class_hotels.txt")
        
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

# Initialize clients for the chatbot
def initialize_clients():
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        raise ValueError("OPENAI_API_KEY is not set in the environment variables.")
    openai_client = OpenAI(
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
    
    memory_fast = ConversationBufferMemory(return_messages=True)
    memory_lengthy = ConversationBufferMemory(return_messages=True)
    
    return openai_client, tavily_client, memory_fast, memory_lengthy, gemini_model

#Setup for Travel planner
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))

tavily_api_key = os.getenv("TAVILY_API_KEY")
if not tavily_api_key:
    raise ValueError("TAVILY_API_KEY is not set in the environment variables.")
tavily_client = TavilyClient(tavily_api_key)

generation_config = {
    "temperature": 0.9,
    "top_p": 1,
    "top_k": 1,
    "max_output_tokens": 4048,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
)

places_instance = Places()

def filter_places_by_categories(interested_categories):
    return places_instance.filter_places_by_categories(interested_categories)

script_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
pkl_path = os.path.join(script_dir, 'Recommendation Model', 'Recommendation Model.pkl')
with open(pkl_path, 'rb') as file:
    loaded_recommender = dill.load(file)


# Generate response for the chatbot
def generate_response(prompt, openai_client, tavily_client, vector_store, memory_fast, memory_lengthy, gemini_model, is_fast_mode):

    def get_openai_response(prompt):
        try:
            completion = openai_client.chat.completions.create(
                model="meta/llama-3.1-405b-instruct",
                messages=[
                    {"role": "system", "content": "You are a helpful assistant and a travel guide who is very knowledgeable about Sri Lanka and its culture, history, and tourism facilities."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.5,
                top_p=0.7,
                max_tokens=4096
            )
            return completion.choices[0].message.content
        except AttributeError:
            return completion
        except Exception as e:
            print(f"Error in get_openai_response: {e}")
            return "An error occurred while processing your request. Try again later."
    
    def get_gemini_response(prompt):
        chat_session = gemini_model.start_chat()
        final_prompt = f""" 
        "role": "system", "content": "You are a helpful assistant and a travel guide who is very knowledgeable about Sri Lanka and its culture, history, and tourism facilities.
        "role": "user", "content": {prompt}"""
        response = chat_session.send_message(final_prompt)
        return response.text
    
    context = retrieve_context(prompt, vector_store)    

    history = memory_fast.load_memory_variables({}) if is_fast_mode else memory_lengthy.load_memory_variables({})

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
    
    Answer:
    """
    print("full_prompt: ", full_prompt)
    if is_fast_mode:
        final_response = get_gemini_response(full_prompt)
        memory_fast.save_context({"input": prompt}, {"output": final_response})
        return final_response
    else:
        final_response = get_openai_response(full_prompt)
        memory_lengthy.save_context({"input": prompt}, {"output": final_response})
        return final_response

# Extract itinerary details from the response
def extract_itinerary_details(text):
    days = re.split(r'Day \d+:', text)[1:]
    itinerary = {}
    for i, day in enumerate(days, 1):
        day_title = re.search(r'(.*?)\n', day.strip()).group(1).strip().replace('[', '').replace(']', '').replace('*', '')
        day_key = f"Day {i}: {day_title}"

        description_match = re.search(r'Description:\s*(.*?)(?=\n-\s*Activities:|\Z)', day, re.DOTALL)
        description = description_match.group(1).strip() if description_match else ""

        activities_match = re.search(r'Activities:\s*(.*?)(?=\Z)', day, re.DOTALL)
        activities = activities_match.group(1).strip().split('|') if activities_match else []
        activities = [activity.strip().lstrip('-,') for activity in activities if activity.strip()]

        itinerary[day_key] = {
            'Description': description,
            'Activities': activities
        }

    return itinerary

# Process locations from the itinerary
def process_locations(itinerary):
    Locations = [day.split(':')[1].strip() for day in itinerary.keys()]
    expanded_loc = []
    for item in Locations:
        if '-' in item:
            parts = [part.strip().replace('[', '').replace(']', '').replace('*', '') for part in item.split('-')]
            expanded_loc.extend(parts)
        else:
            expanded_loc.append(item.replace('[', '').replace(']', '').replace('*', ''))

    unique_loc = []
    previous_item = None
    for item in expanded_loc:
        if item != previous_item:
            unique_loc.append(item)
        previous_item = item

    return unique_loc


# Retrieve context from the vector store
def retrieve_context(query, vector_store, top_k=5):
    results = vector_store.similarity_search_with_score(query, k=top_k)
    weighted_context = ""
    for doc, score in results:
        weighted_context += f"{doc.page_content} (relevance: {score})\n\n"
    return weighted_context



vector_store = create_vector_db()
openai_client, tavily_client, memory_fast, memory_lengthy, gemini_model = initialize_clients()


# Recommend places based on user's activities and bucket list
@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        data = request.json
        user_activities = data.get('user_activities', [])
        user_bucket_list = data.get('user_bucket_list', [])
        print("user_activities: ", user_activities)
        print("user_bucket_list: ", user_bucket_list)

        if not isinstance(user_activities, list) or not isinstance(user_bucket_list, list):
            return jsonify({'error': 'Invalid input format.'}), 400

        recommended_places = loaded_recommender.recommend_top_places(user_activities, user_bucket_list)
        print("recommended_places: ", recommended_places)
        
        return jsonify(recommended_places)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Generate itinerary for the user
@app.route('/plan', methods=['POST'])
def generate_itinerary():
    try:
        data = request.json
        selected_categories = data.get('selectedCategories', [])
        recommended_places = data.get('recommendedPlaces', [])
        duration = data.get('duration')

        print("printing data received")   
        print("recommended_places: ", recommended_places)
        print("selected_categories: ", selected_categories)
        print("duration: ", duration)

        filtered_places = filter_places_by_categories(selected_categories)
        chat_session = model.start_chat(history=[])

        response = chat_session.send_message(f"[AI Role: Trip planning expert inside Sri Lanka]\n"
                                             f"Travel places: {recommended_places}\n"
                                             f"A tourist who is in love with {selected_categories} wants to travel to various destinations in Sri Lanka. "
                                             f"Based on the Travel places provided. Create a {duration} -day travel plan that starts and ends at BIA Airport "
                                             f"with minimizing the travel distance whenever it can also need to minimize the travel distance. "
                                             f"The plan should recommend the best matching places to visit, where to stay each night, and what to do each day. "
                                             f"Ensure that the plan fits within the {duration} days available. \n \n"
                                             f"Format the output as follows, without using any markdown syntax: \n \n"
                                             f"Day number: [Place where the tourist stays in that day, if there are many separate using '-'] \n"
                                             f"- Description:  \n"
                                             f"- [Little description to the day start and end of the day] \n"
                                             f"- Activities:  \n"
                                             f"- [Suggest some activities(maximum 5) separated by '|' sign (Only that don't add any other)] \n"
                                             f"Please provide a detailed itinerary that ensures the tourist has a fulfilling experience each day, ")

        print("response.text: ", response.text)
        itinerary = extract_itinerary_details(response.text)
        expanded_loc = process_locations(itinerary)

        return jsonify({'itinerary': itinerary, 'expanded_loc': expanded_loc})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Get accommodations for the user
@app.route('/get_accommodations', methods=['POST'])
def get_accommodations():
    try:
        data = request.json
        expandedLoc = data.get('expandedLoc')
        selectedAccommodations = data.get('selectedAccommodations')

        print("printing data received")   
        # print(expandedLoc)
        # print(selectedAccommodations)

        prompt =f"{expandedLoc}"

        context = retrieve_context(prompt, vector_store,5)
        print("context: ", context)

        tavily_context = ""
        for place in expandedLoc:
            tavily_result = tavily_client.search(query=f"{selectedAccommodations} Type Accommodation details(name, rating, contact details) for {place}")
            tavily_result = tavily_result['results']
            tavily_context += f"Accommodation for {place}: {tavily_result}\n"

        print("tavily_context: ", tavily_context)

        chat_session = model.start_chat(history=[])

        final_prompt = f"""Role: You are a travel location expert in Sri Lanka
                        use the given accomodations available to give me the best accomodation options for each each unique location (give full information about the accomodation like the name of the hotel, the location, the rating, and the contact numbers): {expandedLoc}

                        The return format needs to be in following format only that do not add any other text:

                        location: location name
                        3 or less accomodations for that location (The accomodations should be in the following format)
                        Name of the hotel:
                        Rating:
                        Contact details(phone number, email, website):

                        If there are no accomodations available in that location, then add 'No accomodations available right now try searching in the web'

                        The response should be user friendly and attractive   

                        Main accomodations available: {context}
                        Additional accomodations available: {tavily_context}
"""
        
        response = chat_session.send_message(final_prompt)
        print("response.text: ", response.text)

        itinerary = extract_itinerary_details(response.text)
        expanded_loc = process_locations(itinerary)

        return jsonify({'itinerary': itinerary, 'expanded_loc': expanded_loc})
    except Exception as e:
        print("error: ", e)
        return jsonify({'error': str(e)}), 500                                             


# Chat with the chatbot
@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        user_message = data.get('message')
        gpt_selection = data.get('gpt_selection')  # Get GPT selection
        is_fast_mode = data.get('isFastMode', True)  # Get isFastMode, default to True
        print("user_message: ", user_message)
        print("gpt_selection: ", gpt_selection)  # Log GPT selection
        print("is_fast_mode: ", is_fast_mode)  # Log isFastMode
        if not user_message:
            return jsonify({'error': 'No message provided.'}), 400
        
        vector_store

        response = generate_response(user_message, openai_client, tavily_client, vector_store, memory_fast, memory_lengthy, gemini_model,is_fast_mode)   
        print("response: ", response)

        return jsonify({'response': response})
    except Exception as e:
        print(f"Error in /chat endpoint: {e}")
        return jsonify({'error': str(e)}), 500
    
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)