# Sri Lanka Travel Companion App

## Project Overview
Trip Planner is an intelligent travel itinerary generation app designed to help users plan personalized trips across Sri Lanka. This app uses AI to create optimized itineraries based on user preferences, such as preferred activities, categories, and available time. The application includes a back-end server that interacts with external APIs to enhance the planning process and provide detailed trip suggestions.

## Features
- **User Inputs:** Users can select categories (e.g., Seaside, Wildlife, Cultural) and dates for their travel.
- **Itinerary Generation:** The Python backend connects with Gemini APIs to generate daily itineraries based on selected inputs.
- **Interactive UI:** The app allows users to view their itinerary, with detailed daily plans and locations displayed on a map.
- **LatLng Support:** The app displays relevant places on a map by fetching latitude and longitude data for each location.
- **Real-time Data Fetching:** Data is dynamically fetched based on user inputs, ensuring that suggestions are always up-to-date.
- **AI-Powered Recommendations:** Utilizes a recommendation model to suggest personalized destinations based on user preferences and historical data.
- **RAG-based AI Chatbot:** Features a Language Model-based AI agent that provides:
  - Contextual travel information
  - Real-time answers to user queries
  - Personalized recommendations using RAG (Retrieval Augmented Generation)
  - Integration with multiple AI models (OpenAI, Gemini, Tavily)

## Tech Stack
- **Flutter:** The app is built using Flutter for cross-platform mobile development.
- **Python:** The back-end server is built in Python, providing API integrations and itinerary generation logic.
- **Gemini APIs:** Used for enhanced itinerary generation and data fetching.
- **Vector Databases:** FAISS for efficient similarity search and retrieval of travel information.
- **LangChain:** For building and managing the RAG-based chatbot system.
- **HuggingFace Models:** Utilized for embeddings and text processing.

## Setup Instructions

### Prerequisites
1. **Flutter SDK** – For building and running the mobile app.
2. **Python 3.x** – For running the back-end server.
3. **Gemini API Key** – The API key is saved in the given `.env` file.
4. **Additional API Keys** – Required for OpenAI, Tavily, and other integrated services.

### Clone the Repository
```bash
git clone https://github.com/AkinduH/Sri-Lanka-Travel-Companion-App.git
cd trip_planner_team_9th_dimension
```
### Install dependencies
```bash
pip install -r requirements.txt
flutter pub get
```
### Add the `.env` file in to the project
Configure all required API keys in the environment file.

### Run the server
```bash
python python_backend.py
```
### Run the app locally
```bash
flutter run
```
