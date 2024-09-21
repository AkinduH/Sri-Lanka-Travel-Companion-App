import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from itertools import combinations, permutations
import ast
import dill
import os

# Ensure the correct path to the CSV file
script_dir = os.path.dirname(os.path.realpath(__file__))
csv_path = os.path.join(script_dir, 'users_preprocessed.csv')

users_df = pd.read_csv(csv_path)

# Ensure the correct path to the pickle file
pkl_path = os.path.join(script_dir, 'Recommendation Model.pkl')
with open(pkl_path, 'rb') as file:
    loaded_recommender = dill.load(file)

# Enter user number 
user_number = 5

# Example input
user_activities = users_df.iloc[user_number]['Preferred Activities'].strip("[]").replace("'", "").split(", ")
user_bucket_list = users_df.iloc[user_number]['Bucket list destinations Sri Lanka'].strip("[]").replace("'", "").split(", ")

print("User Preferred Activities:")
for activity in user_activities:
    print(f"- {activity}")

print("\nUser Bucket List Destinations in Sri Lanka:")
for destination in user_bucket_list:
    print(f"- {destination}")

best_route = loaded_recommender.recommend_top_places(user_activities, user_bucket_list)
print(f"\nFinal recommended places:")
for place in best_route:
    print(f"Place: {place}")