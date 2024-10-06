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
// }

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
