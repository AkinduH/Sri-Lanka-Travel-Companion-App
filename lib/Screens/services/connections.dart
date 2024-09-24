import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class connections {
  Future<Map<String, dynamic>> sendDataToBackend(
    List<String> selectedCategories,
    List<String> bucketList,
    List<String> recommendations,
    DateTime startDate,
    DateTime endDate,
    int duration,
  ) async {
    final url = Uri.parse('http://127.0.0.1:5000/plan');
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
    final url = Uri.parse('http://127.0.0.1:5000/get_accommodations');
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
      String message, String? gptSelection) async {
    // Modify method signature
    final url = Uri.parse('http://127.0.0.1:5000/chat');
    try {
      final body = {
        'message': message,
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
