import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//users api
class ApiServices {
  static const String baseUrl =
      'https://mentalease.ccsdepartment.com/MentalEase_Database/users_account/users_api.php'; // New API URL

  Future<Map<String, dynamic>> getMoodHistory(String idNumber) async {
    final url =
        Uri.parse('$baseUrl?action=get_mood_history&id_number=$idNumber');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'] ?? {};
      } else {
        throw Exception(data['message'] ?? 'Failed to load mood history');
      }
    } else {
      throw Exception('Failed to load mood history');
    }
  }

  Future<Map<String, dynamic>> getMoodData(String idNumber) async {
    final url = Uri.parse('$baseUrl');
    final response = await http.post(
      url,
      body: {
        'action': 'get_mood_data',
        'id_number': idNumber,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'] ?? {};
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to fetch mood data');
    }
  }

  // Mood Tracker function
  Future<void> updateMoodForUser(
      BuildContext context, String idNumber, String day, String mood) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: {
        'action': 'update_mood',
        'id_number': idNumber,
        'day': day,
        'mood': mood,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mood updated successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update mood: ${data['message']}")),
      );
    }
  }

  // Sign-Up function
  Future<Map<String, dynamic>> signUp(
      String idNumber, String email, String password) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: {
        'action': 'signup', // Action to trigger sign-up
        'id_number': idNumber,
        'email': email,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  // Sign-In function
  Future<Map<String, dynamic>> signIn(String idNumber, String password) async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      body: {
        'action': 'signin', // Action to trigger sign-in
        'id_number': idNumber,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }
}

//admin api
class ApiService {
  static const String baseUrl =
      'https://mentalease.ccsdepartment.com/MentalEase_Database/api.php';

  Future<Map<String, dynamic>> verifyCode(
      Map<String, dynamic> verificationData) async {
    final url = Uri.parse('$baseUrl/verify');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(verificationData),
    );

    return jsonDecode(response.body);
  }

  //Sign-In
  Future<Map<String, dynamic>> signIn(Map<String, dynamic> credentials) async {
    final url = Uri.parse('$baseUrl/signin');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials),
    );

    return jsonDecode(response.body);
  }

  // Get Quote of the Day
  Future<String> getQuoteOfTheDay() async {
    // Get the current weekday name (Sunday, Monday, etc.)
    final weekday = DateTime.now().weekday;

    final dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    final day = dayNames[weekday % 7]; // Get current day name

    // Construct URL for the API request
    final url = Uri.parse('$baseUrl/api/quotes/$day');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['quotes'] ?? 'No quote available for today.';
      } else {
        return 'Error fetching quote: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error fetching quote: $e';
    }
  }
}
