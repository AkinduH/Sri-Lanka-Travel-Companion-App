import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// ignore: camel_case_types
class connections {
  Future<Map<String, dynamic>> sendDataToBackend(
    List<String> selectedCategories,
    DateTime startDate,
    DateTime endDate,
    int duration,
  ) async {
    final url = Uri.parse('http://127.0.0.1:5000/api');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'selectedCategories': selectedCategories,
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
