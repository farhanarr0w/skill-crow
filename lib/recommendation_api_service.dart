import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<dynamic, dynamic>> getRecommendedFreelancers(
      String title, String description) async {
    final url = Uri.parse('$baseUrl/recommend');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'JobTitle': title,
        'JobDescription': description,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception('Failed to get recommendations');
    }
  }
}
