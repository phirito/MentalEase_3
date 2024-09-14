import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://your_server_address/backend/index.php'; // Replace with your server address

  // Sign-Up
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    return jsonDecode(response.body);
  }

  // Sign-In
  Future<Map<String, dynamic>> signIn(Map<String, dynamic> credentials) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials),
    );

    return jsonDecode(response.body);
  }
}
