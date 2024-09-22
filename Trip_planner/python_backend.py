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
import ast
import dill

def configure():
    load_dotenv()

app = Flask(__name__)

# Configure CORS
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# Configure Gemini API
genai.configure(api_key=os.getenv('GEMINI_API_KEY'))

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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)