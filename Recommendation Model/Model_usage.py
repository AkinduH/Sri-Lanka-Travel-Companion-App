# import numpy as np
# import pandas as pd
# from sklearn.feature_extraction.text import TfidfVectorizer
# from sklearn.metrics.pairwise import cosine_similarity
# from itertools import combinations, permutations
# import ast
# import dill
# import os
# from flask import Flask, request, jsonify
# from flask_cors import CORS

# app = Flask(__name__)
# CORS(app)

# script_dir = os.path.dirname(os.path.realpath(__file__))
# pkl_path = os.path.join(script_dir, 'Recommendation Model.pkl')
# with open(pkl_path, 'rb') as file:
#     loaded_recommender = dill.load(file)
    
# @app.route('/recommend', methods=['POST'])
# def recommend():
#     try:
#         data = request.json
#         user_activities = data.get('user_activities', [])
#         user_bucket_list = data.get('user_bucket_list', [])
#         print("user_activities: ", user_activities  )
#         print("user_bucket_list: ", user_bucket_list)

#         if not isinstance(user_activities, list) or not isinstance(user_bucket_list, list):
#             return jsonify({'error': 'Invalid input format.'}), 400

#         recommended_places = loaded_recommender.recommend_top_places(user_activities, user_bucket_list)
#         print("recommended_places: ", recommended_places)

#         return jsonify(recommended_places)
#     except Exception as e:
#         return jsonify({'error': str(e)}), 500


# if __name__ == '__main__':
#     app.run(debug=True, host='0.0.0.0')