// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class RecommendationModel {
//   static const String _baseUrl = 'http://192.168.1.3:5000';

//   static Future<List<String>> getRecommendations(
//       List<String> categories, List<String> bucketList) async {
//     final url = Uri.parse('$_baseUrl/recommend');

//     final payload = {
//       'user_activities': categories,
//       'user_bucket_list': bucketList,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         // Ensure all items are strings
//         return data.map((item) => item.toString()).toList();
//       } else {
//         // Try to decode error message from backend
//         String errorMessage = 'Failed to get recommendations.';
//         try {
//           Map<String, dynamic> errorData = jsonDecode(response.body);
//           if (errorData.containsKey('error')) {
//             errorMessage = errorData['error'];
//           }
//         } catch (_) {}
//         throw Exception(
//             'Error: $errorMessage (Status code: ${response.statusCode})');
//       }
//     } catch (e) {
//       throw Exception('Error while fetching recommendations: $e');
//     }
//   }
// }
