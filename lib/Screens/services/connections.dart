import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Connections {
  static const String _baseUrl =
      'http://13.51.159.48:5000'; // Server 'http://13.51.159.48:5000'; Local 'http://127.0.0.1:5000';

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

  Future<String> getAccommodations({
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
      return jsonResponse['response'];
    } else {
      throw Exception('Failed to fetch accommodations');
    }
  }

  Future<Map<String, String>> sendMessageToChatbot(
      String message, bool isFastMode) async {
    final url = Uri.parse('$_baseUrl/chat');
    try {
      final body = {
        'message': message,
        'isFastMode': isFastMode,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return {
          'response': jsonResponse['response'] as String,
          'selected_agent': jsonResponse['selected_agent'] as String,
        };
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      print('Error in sendMessageToChatbot: $e');
      return {
        'response':
            'I apologize, but an error occurred while processing your request. Please try again in a moment or rephrase your question.'
      };
    }
  }

  Future<String> uploadAudio(String filePath) async {
    final url = Uri.parse('$_baseUrl/transcribe');
    var request = http.MultipartRequest('POST', url);

    // Send only the file path
    request.fields['filepath'] = filePath;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        return jsonResponse['transcription'] as String;
      } else {
        throw Exception('Failed to transcribe audio');
      }
    } catch (e) {
      throw Exception('Error while transcribing audio: $e');
    }
  }
}
