import 'package:http/http.dart' as http;
import 'dart:convert';

// Future<void> fetchUsers() async {
//   final response = await http.get(Uri.parse( 'https://mentalease.ccsdepartment.com/MentaleEase_Database/api.php/'));

//   if (response.statusCode == 200) {
//     List<dynamic> users = json.decode(response.body);
//     print(users); // Handle your users data here
//   } else {
//     throw Exception('Failed to load users');
//   }
// }MentalEase@2024

Future<void> signUpUser(String username, String email, String password) async {
  var url = Uri.parse(
      'https://mentalease.ccsdepartment.com/MentaleEase_Database/api.php/');
  var response = await http.post(url, body: {
    'username': username,
    'email': email,
    'password': password,
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      print("Sign-up successful!");
    } else {
      print("Sign-up failed: ${data['message']}");
    }
  } else {
    print("Error: ${response.reasonPhrase}");
  }
}

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
    // ignore: avoid_print
    print("Mood updated successfully");
  } else {
    throw Exception('Failed to update mood');
  }
}
