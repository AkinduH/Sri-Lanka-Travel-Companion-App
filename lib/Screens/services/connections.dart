import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Connections {
  static const String _baseUrl = 'http://127.0.0.1:5000'; // Update if necessary

  Future<List<String>> getRecommendations(
      List<String> categories, List<String> bucketList) async {
    final url = Uri.parse('$_baseUrl/recommend');

    final payload = {
      'user_activities': categories,
      'user_bucket_list': bucketList,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Ensure all items are strings
        return data.map((item) => item.toString()).toList();
      } else {
        // Try to decode error message from backend
        String errorMessage = 'Failed to get recommendations.';
        try {
          Map<String, dynamic> errorData = jsonDecode(response.body);
          if (errorData.containsKey('error')) {
            errorMessage = errorData['error'];
          }
        } catch (_) {}
        throw Exception(
            'Error: $errorMessage (Status code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error while fetching recommendations: $e');
    }
  }

  Future<Map<String, dynamic>> sendDataToBackend(
    List<String> selectedCategories,
    List<String> bucketList,
    List<String> recommendations,
    DateTime startDate,
    DateTime endDate,
    int duration,
  ) async {
    final url = Uri.parse('$_baseUrl/plan');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'selectedCategories': selectedCategories,
        'bucketList': bucketList,
        'recommendedPlaces': recommendations,
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
        'endDate': DateFormat('yyyy-MM-dd').format(endDate),
        'duration': duration,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load your Plan');
    }
  }

  Future<Map<String, dynamic>> getAccommodations({
    required List<dynamic> expandedLoc,
    required List<String> selectedAccommodations,
  }) async {
    final url = Uri.parse('$_baseUrl/get_accommodations');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'expandedLoc': expandedLoc,
        'selectedAccommodations': selectedAccommodations,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch accommodations');
    }
  }

  Future<String> sendMessageToChatbot(
      String message, String? gptSelection, bool isFastMode) async {
    final url = Uri.parse('$_baseUrl/chat');
    try {
      final body = {
        'message': message,
        'isFastMode': isFastMode, // Include isFastMode in the body
      };
      if (gptSelection != null) {
        body['gpt_selection'] = gptSelection;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['response'] as String;
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      print('Error in sendMessageToChatbot: $e');
      return 'An error occurred. Please try again.';
    }
  }
}
