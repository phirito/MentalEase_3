import 'dart:convert';
import 'package:http/http.dart' as http;

//users api
class ApiServices {
  static const String baseUrl =
      'https://mentalease.ccsdepartment.com/MentalEase_Database/users_account/users_api.php'; // New API URL

  // Mood Tracker function
  Future<void> updateMoodForUser(String weekday, String mood) async {
    final url = Uri.parse('$baseUrl');
    final response = await http.post(
      url,
      body: {
        'action': 'update_mood',
        'weekday': weekday,
        'mood': mood,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update mood');
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

  // Sign-Up
  // Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData) async {
  //   final url = Uri.parse('$baseUrl'); // This should call your `signupapi.php`
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(userData),
  //   );

  //   return jsonDecode(response.body);
  // }

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
