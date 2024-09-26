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
from huggingface_hub import InferenceClient
import time
import dill
from speechmatics.models import ConnectionSettings, BatchTranscriptionConfig
from speechmatics.batch_client import BatchClient
from httpx import HTTPStatusError
import tempfile  # Ensure tempfile is imported

load_dotenv()

app = Flask(__name__)

# Configure CORS
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# Create vector databases 
def create_vector_db(resource_folder, subfolder, filename):
    try:
        script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
        file_path = os.path.join(script_dir, "trip_planner_team_9th_dimension", "LLM based AI Agent", "RAG_Documents", resource_folder, subfolder, filename)
        
        with open(file_path, "r", encoding="utf-8") as file:
            text = file.read()
        print(f"File {filename} read successfully")
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

def create_vector_db_from_folder(resource_folder, subfolder = None):
    try:
        script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
        base_path = os.path.join(script_dir, "trip_planner_team_9th_dimension", "LLM based AI Agent", "RAG_Documents", resource_folder)
        
        if subfolder is None or subfolder == "":
            folder_path = base_path
        else:
            folder_path = os.path.join(base_path, subfolder)
        
        all_text = ""
        for filename in os.listdir(folder_path):
            if filename.endswith(".txt"):
                file_path = os.path.join(folder_path, filename)
                with open(file_path, "r", encoding="utf-8") as file:
                    all_text += file.read() + "\n\n"
        print(f"All files in the folder {folder_path} read successfully")
    except Exception as e:
        print(f"Error reading files from folder: {e}")
        return None
    
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
    chunks = text_splitter.split_text(all_text)
    
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    vector_store = FAISS.from_texts(chunks, embeddings)
    return vector_store

# Creating SLM client
SLM = InferenceClient(
    "mistralai/Mistral-7B-Instruct-v0.1",
    token=os.getenv("HuggingFace_API_KEY"),
)

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
        "temperature": 0.5,
        "top_p": 0.9,
        "top_k": 20,
        "max_output_tokens": 1024,
    }
    
    gemini_model = genai.GenerativeModel(
        model_name="gemini-1.5-flash",
        generation_config=generation_config,
    )
    
    memory = ConversationBufferMemory(return_messages=True)
    
    return openai_client, tavily_client, memory, gemini_model

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
def generate_response(prompt, openai_client, tavily_client, vector_store, memory, gemini_model, is_fast_mode):

    def get_openai_response(prompt):
        try:
            completion = openai_client.chat.completions.create(
                model="meta/llama-3.1-405b-instruct",
                messages=[
                    {"role": "system", "content": "You are a concise Sri Lanka travel expert. Provide accurate, detailed responses focusing on key attractions, accommodations, transport, and local insights."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.2,
                top_p=0.95,
                max_tokens=3096,
                presence_penalty=0.05,
                frequency_penalty=0.05
            )
            return completion.choices[0].message.content
        except AttributeError as ae:
            print(f"AttributeError in get_openai_response: {ae}")
            return "I apologize, but I'm having trouble accessing the required information. Could you please rephrase your question?"
        except Exception as e:
            print(f"Error in get_openai_response: {e}")
            return "I apologize, but an error occurred while processing your request. Please try again in a moment or rephrase your question."
    
    def get_gemini_response(prompt):
        chat_session = gemini_model.start_chat()
        final_prompt = f""" 
        "role": "system", "content": "You are a quick travel guide for Sri Lanka. Provide concise, accurate answers about Sri Lankan tourism, culture, and attractions.
        "role": "user", "content": {prompt}"""
        response = chat_session.send_message(final_prompt)
        return response.text
    
    if(vector_store == ""):
        context = "No context available"
    else:
        context = retrieve_context(prompt, vector_store)    
    
    print("context: ", context)

    history = memory.load_memory_variables({})

    history_context = "\n".join([f"{m.type}: {m.content}" for m in history.get("history", [])])
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
    If the user Question is a general one that doen't need to use context and additional context to answer, then don't use them.
    If context and additional context are not available, then don't mention them or worry about them.
    The details use recieve from context and additional context are accurate don't show any doubts in your response.
    Give the response in a friendly and engaging tone.
    
    Answer:
    """
    # print("full_prompt: ", full_prompt)
    if is_fast_mode:
        final_response = get_gemini_response(full_prompt)
        memory.save_context({"input": prompt}, {"output": final_response})
        return final_response
    else:
        final_response = get_openai_response(full_prompt)
        memory.save_context({"input": prompt}, {"output": final_response})
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


script_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
vector_dbs_dir = os.path.join(script_dir, "trip_planner_team_9th_dimension", "LLM based AI Agent", "Vector DBs")

embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

star_class_hotels_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "star_class_hotels_vector_store"), embeddings, allow_dangerous_deserialization=True)
boutique_villas_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "boutique_villas_vector_store"), embeddings, allow_dangerous_deserialization=True)
bungalows_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "bungalows_vector_store"), embeddings, allow_dangerous_deserialization=True)
camping_sites_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "camping_sites_vector_store"), embeddings, allow_dangerous_deserialization=True)
home_stays_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "home_stays_vector_store"), embeddings, allow_dangerous_deserialization=True)
normal_hotels_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "normal_hotels_vector_store"), embeddings, allow_dangerous_deserialization=True)   
tourism_resorts_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "tourism_resorts_vector_store"), embeddings, allow_dangerous_deserialization=True)
tourist_shops_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "tourist_shops_vector_store"), embeddings, allow_dangerous_deserialization=True)
agents_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "agents_vector_store"), embeddings, allow_dangerous_deserialization=True)
places_to_stay_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "places_to_stay_vector_store"), embeddings, allow_dangerous_deserialization=True)
transport_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "transport_vector_store"), embeddings, allow_dangerous_deserialization=True)
default_vector_store = FAISS.load_local(os.path.join(vector_dbs_dir, "default_vector_store"), embeddings, allow_dangerous_deserialization=True)


openai_client, tavily_client, memory, gemini_model = initialize_clients()


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

        prompt =f"{expandedLoc}"

        context = ""
        
        # Choose the appropriate vector store based on selectedAccommodations
        if 'Star Hotels' in selectedAccommodations:
            vector_store = star_class_hotels_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Normal Hotels' in selectedAccommodations:
            vector_store = normal_hotels_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Sri Lanka Tourism Resorts' in selectedAccommodations:
            vector_store = tourism_resorts_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Boutique Villas' in selectedAccommodations:
            vector_store = boutique_villas_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Bungalows' in selectedAccommodations:
            vector_store = bungalows_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Home Stays' in selectedAccommodations:
            vector_store = home_stays_vector_store
            context+=retrieve_context(prompt, vector_store,5)
        if 'Camping Sites' in selectedAccommodations:
            vector_store = camping_sites_vector_store
            context+=retrieve_context(prompt, vector_store,5)   
        else:
            vector_store = places_to_stay_vector_store
            context+=retrieve_context(prompt, vector_store,5)

    
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
        is_fast_mode = data.get('isFastMode', True)  # Get isFastMode, default to True
        print("user_message: ", user_message)
        print("is_fast_mode: ", is_fast_mode)  # Log isFastMode
        if not user_message:
            return jsonify({'error': 'No message provided.'}), 400

        SLM_prompt = f"""
        Role: GPT selector based on the user message.

        We have the following agents: AgentGPT, StayGPT, TransportGPT, ShopGPT, GreetingGPT.
        Select the most suitable agent based on the user message.
        User message: {user_message}
        If the user message doesn't match any specific agent, respond with DefaultGPT.

        Here is the description of each agent:
        AgentGPT for questions related to travel agents, travel agencies, and travel guides in sri lanka.
        StayGPT for questions related to finding places to stay, hotels, and accommodation in sri lanka.
        TransportGPT for questions related to transport, transportation like taxies, buses, and trains in sri lanka.
        ShopGPT for questions related to finding tourist shops, shopping in sri lanka.
        GreetingGPT for greetings from  the user.

        Respond with only the selected agent name, nothing else. No need to add any other text.

        For examples of a correct response:
        example 1: AgentGPT
        example 2: StayGPT

        """
        
        start_time = time.time()
        
        SLM_response = ""
        for message in SLM.chat_completion(
            messages=[{"role": "user", "content": SLM_prompt}],
            max_tokens=500,
            stream=True,
        ):
            content = message.choices[0].delta.content
            if content:
                print(content, end="")
                SLM_response += content

        end_time = time.time()
        process_time = end_time - start_time
        
        print(f"\nSLM_response: {SLM_response.strip()}")
        print(f"Process time: {process_time:.2f} seconds")

        selected_agent = "General"
        
        if "AgentGPT" in SLM_response:
            vector_store = agents_vector_store
            selected_agent = "Tour Agent"
            print("vector_store: agents_vector_store")
        elif "StayGPT" in SLM_response:
            vector_store = places_to_stay_vector_store
            selected_agent = "Stay Specialist"
            print("vector_store: places_to_stay_vector_store")
        elif "TransportGPT" in SLM_response:
            vector_store = transport_vector_store
            selected_agent = "Transport Specialist"
            print("vector_store: transport_vector_store")
        elif "ShopGPT" in SLM_response:
            vector_store = tourist_shops_vector_store   
            selected_agent = "Shop Specialist"
            print("vector_store: tourist_shops_vector_store")
        elif "GreetingGPT" in SLM_response:
            vector_store = ""
            selected_agent = "General"
            print("vector_store: None")
        else:
            vector_store = default_vector_store
            selected_agent = "General"
            print("vector_store: default_vector_store")

        start_time = time.time()
        response = generate_response(user_message, openai_client, tavily_client, vector_store, memory, gemini_model,is_fast_mode)   
        end_time = time.time()
        process_time = end_time - start_time
        print("response: ", response)
        print(f"Generate response time: {process_time:.2f} seconds")

        return jsonify({'response': response, 'selected_agent': selected_agent})
    except Exception as e:
        print(f"Error in /chat endpoint: {e}")
        return jsonify({'error': str(e)}), 500
    
@app.route('/transcribe', methods=['POST'])
def transcribe_audio():
    if 'filepath' not in request.form:
        return jsonify({'error': 'No file path provided'}), 400

    file_path = request.form['filepath']
    print("file path: ", file_path)

    if not file_path:
        return jsonify({'error': 'Empty file path'}), 400

    try:
        # Use the Speechmatics API to transcribe the audio
        API_KEY = os.getenv("SPEECHMATICS_API_KEY")
        LANGUAGE = "en"

        # Open the client using a context manager
        with BatchClient(API_KEY) as client:
            try:
                job_id = client.submit_job(file_path, BatchTranscriptionConfig(LANGUAGE))
                print(f'job {job_id} submitted successfully, waiting for transcript')

                # Note that in production, you should set up notifications instead of polling.
                # Notifications are described here: https://docs.speechmatics.com/features-other/notifications
                transcript = client.wait_for_completion(job_id, transcription_format='txt')
                print("transcript: ", transcript)

                return jsonify({'transcription': transcript})
            except HTTPStatusError as e:
                if e.response.status_code == 401:
                    return jsonify({'error': 'Invalid API key - Check your API_KEY'}), 401
                elif e.response.status_code == 400:
                    return jsonify({'error': e.response.json()['detail']}), 400
                else:
                    raise e
    except Exception as e:
        return jsonify({'error': str(e)}), 500
         
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)