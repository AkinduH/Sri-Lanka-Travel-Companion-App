from flask import Flask, request, jsonify
import google.generativeai as genai
from flask_cors import CORS
from dotenv import load_dotenv
import os
import re

def configure():
    load_dotenv()

app = Flask(__name__)
CORS(app)
genai.configure(api_key= os.getenv('api_key'))

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

places = {
    'Unawatuna Beach': ['Beaches'],
    'Mirissa Beach': ['Beaches'],
    'Arugam Bay': ['Beaches'],
    'Tangalle Beach': ['Beaches'],
    'Nilaveli Beach': ['Beaches'],
    'Hikkaduwa Beach': ['Beaches'],
    'Trincomalee Beach': ['Beaches'],
    'Bentota Beach': ['Beaches'],
    'Pasikuda Beach': ['Beaches'],
    'Kalpitiya Beach': ['Beaches'],
    'Weligama Beach': ['Beaches'],

    'Kitulgala (White Water Rafting)': ['Adventure'],
    'Ella (Zip Line)': ['Adventure'],
    'Knuckles Five Peaks Mountain': ['Adventure', 'Mountains'],
    'Sigiriya Rock Fortress': ['Cultural'],
    'Adam’s Peak': ['Mountains'],
    'Pallewela Falls': ['Adventure'],
    'Yala National Park': ['Wildlife', 'Adventure'],
    'Gal Oya National Park': ['Wildlife', 'Adventure'],
    'Babarakanda Ella': ['Adventure', 'Waterfalls'],
    'Lanka Ella': ['Adventure', 'Waterfalls'],
    'Sadun Ella': ['Adventure', 'Waterfalls'],

    'Wilpattu National Park': ['Wildlife'],
    'Bundala National Park': ['Wildlife'],
    'Kaudulla National Park': ['Wildlife'],
    'Sinharaja Forest Reserve': ['Wildlife', 'Rainforests'],
    'Kumana National Park': ['Wildlife'],
    'Wasgamuwa National Park': ['Wildlife'],

    'Rambukkana to Kandy': ['Scenic Train Rides'],
    'Kandy to Ella': ['Scenic Train Rides'],
    'Ella to Badulla': ['Scenic Train Rides'],
    'Nuwara Eliya to Ella': ['Scenic Train Rides'],
    'Colombo to Badulla': ['Scenic Train Rides'],
    'Galle to Matara': ['Scenic Train Rides'],
    'Bentota to Galle': ['Scenic Train Rides'],
    'Nuwara Eliya to Haputale': ['Scenic Train Rides'],
    'Anuradhapura to Jaffna': ['Scenic Train Rides'],
    'Polgahawela to Anuradhapura': ['Scenic Train Rides'],
    'Mahawa to Batticaloa': ['Scenic Train Rides'],

    'Dambulla Cave Temple': ['Cultural'],
    'Polonnaruwa Ancient City': ['Cultural'],
    'Anuradhapura Sacred City': ['Cultural'],
    'Temple of the Tooth': ['Cultural'],
    'Ruwanwelisaya': ['Cultural'],
    'Jethawanaramaya': ['Cultural'],
    'Mihintale': ['Cultural'],
    'Yapahuwa Rock Fortress': ['Cultural'],
    'Gal Viharaya': ['Cultural'],
    'Aluvihare Rock Temple': ['Cultural'],

    'Diyaluma Falls': ['Waterfalls'],
    'Baker’s Falls': ['Waterfalls'],
    'Aberdeen Falls': ['Waterfalls'],
    'Laxapana Falls': ['Waterfalls'],
    'St. Clair’s Falls': ['Waterfalls'],
    'Bomburu Ella': ['Waterfalls'],
    'Bopath Ella Falls': ['Waterfalls'],
    'Ramboda Falls': ['Waterfalls'],
    'Duwili Ella': ['Waterfalls'],
    'Geradi Ella': ['Waterfalls'],
    'Sari Ella': ['Waterfalls'],

    'Adam’s Peak (Sri Pada)': ['Mountains'],
    'Pidurutalagala': ['Mountains'],
    'Kirigalpotta': ['Mountains'],
    'Thotupola Kanda': ['Mountains'],
    'Namunukula': ['Mountains'],
    'Bible Rock': ['Mountains'],
    'Gombaniya Peak': ['Mountains'],
    'Knuckles Peak': ['Mountains'],
    'Ritigala': ['Mountains'],
    'Yakunge Kanda': ['Mountains'],
    'Wamarapugala': ['Mountains'],
    
    'Makandawa Rainforest': ['Rainforests'],
    'Knuckles Forest Reserve': ['Rainforests'],

    'Nuwara Eliya Tea Plantation': ['Tea Plantations'],
    'Pedro Tea Estate': ['Tea Plantations'],
    'Loolkandura Tea Estate': ['Tea Plantations'],
    'Blangoda Tea Plantations': ['Tea Plantations'],
    'Haputale Tea Plantations': ['Tea Plantations'],
    'Dambatenne Tea Factory': ['Tea Plantations'],
    'Mlesna Tea Castle': ['Tea Plantations'],
    'Bogawantalawa Valley': ['Tea Plantations'],

    'Horton Plains (World’s End)': ['Hiking Trails', 'Mountains'],
    'Devil’s Staircase': ['Hiking Trails', 'Mountains'],
    'Dothalugala Trail': ['Hiking Trails', 'Mountains'],
    'Sinharaja Rainforest Trails': ['Hiking Trails', 'Rainforests'],

    'Gangaramaya Temple': ['Cultural'],
    'Jaya Sri Maha Bodhi': ['Cultural'],
    'Kelaniya Raja Maha Vihara': ['Cultural'],
    'Kataragama Temple': ['Cultural'],
    'Lankaramaya': ['Cultural'],
    'Isurumuniya Temple': ['Cultural'],

    'Ancient City of Yapahuwa': ['Cultural'],
    'Panduwasnuwara': ['Cultural'],
    'Dambadeniya': ['Cultural'],
    'Gampola': ['Cultural'],
    'Aluvihare': ['Cultural'],
    'Ratnapura': ['Cultural']
}


def filter_places_by_categories(interested_categories):
    filtered_places = []
    for place, categories in places.items():
        if any(category in categories for category in interested_categories):
            filtered_places.append(place)
    return filtered_places

@app.route('/api', methods=['POST'])
def generate_itinerary():
    data = request.json
    selected_categories = data.get('selectedCategories', [])
    duration = data.get('duration')

    filtered_places = filter_places_by_categories(selected_categories)
    chat_session = model.start_chat(history=[])
    print(filtered_places)

    response = chat_session.send_message(f"[AI Role: Trip planning expert inside Sri Lanka]\n Travel places: {filtered_places}\n A tourist who is in love with {selected_categories} wants to travel to various destinations in Sri Lanka. Based on the Travel places provided. Create a {duration} -day travel plan that starts and ends at BIA Airport with minimizing the travel distance whenever it can also need to minimize the travel distance. The plan should recommend the best matching places to visit, where to stay each night, and what to do each day. Ensure that the plan fits within the {duration} days available. \n \n Format the output as follows, without using any markdown syntax: \n \n Day number: [Place where the tourist stays in that day, if there are many seperate using '-'] \n - Description:  \n - [Little description to the day start and end of the day] \n - Activities:  \n - [Suggest some activities(maximum 5) seperated by '|' sign (Only that don't add any other)] \n - Accommodation: \n - [Suggested only 2 hotel names seperated by '|' sign (Only that don't add any other)] \n \n Please provide a detailed itinerary that ensures the tourist has a fulfilling experience each day, with convenient and practical accommodations and dining options.")
    print(response.text)

    Locations = [] 

    def extract_itinerary_details(text):
        days = re.split(r'Day \d+:', text)[1:]

        itinerary = {}
        for i, day in enumerate(days, 1):
            day_title = re.search(r'(.*?)\n', day.strip()).group(1).strip().replace('[', '').replace(']', '').replace('*', '')
            Locations.append(day_title)
            day_key = f"Day {i}: {day_title}"

            description_match = re.search(r'Description:\s*(.*?)(?=\n-\s*Activities:|\n-\s*Accommodation:|\Z)', day, re.DOTALL)
            description = description_match.group(1).strip() if description_match else ""

            activities_match = re.search(r'Activities:\s*(.*?)(?=\n-\s*Accommodation:|\Z)', day, re.DOTALL)
            activities = activities_match.group(1).strip().split('|') if activities_match else []
            activities = [activity.strip().lstrip('-,') for activity in activities if activity.strip()]

            accommodations_match = re.search(r'Accommodation:\s*(.*?)(?=\n|\Z)', day, re.DOTALL)
            accommodations = accommodations_match.group(1).strip().split('|') if accommodations_match else []
            accommodations = [accommodation.strip().lstrip('-,') for accommodation in accommodations if accommodation.strip()]

            itinerary[day_key] = {
                'Description': description,
                'Activities': activities,
                'Accommodation': accommodations
            }

        return itinerary

    

    itinerary = extract_itinerary_details(response.text)
    Locations = [city.strip() for city in Locations]
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

    print(unique_loc)

    return jsonify({'itinerary': itinerary, 'expanded_loc': unique_loc})

if __name__ == '__main__':
    app.run(debug=True)