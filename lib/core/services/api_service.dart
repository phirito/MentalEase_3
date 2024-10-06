import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://mentalease.ccsdepartment.com/MentalEase_Database/api.php/api/quotes/'; // Replace with your server address
  Future<String> fetchQuoteForDay(String day) async {
    final response = await http.get(
      Uri.parse(
          'https://mentalease.ccsdepartment.com/MentalEase_Database/api.php/api/quotes/$day'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['quotes'] ?? 'No quote available';
    } else {
      throw Exception('Failed to load quote');
    }
  }

  Future<void> updateMoodTracker(String day, String mood) async {
    final response = await http.put(
      Uri.parse(
          'https://mentalease.ccsdepartment.com/MentalEase_Database/api.php/api/mood/$day'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mood': mood,
      }),
    );

    if (response.statusCode == 200) {
      print("Mood updated successfully");
    } else {
      throw Exception('Failed to update mood');
    }
  }

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
