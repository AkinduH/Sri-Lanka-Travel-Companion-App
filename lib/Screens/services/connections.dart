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
}
