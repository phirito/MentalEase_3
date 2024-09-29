import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/users'));

    if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        print(users); // Handle your users data here
    } else {
        throw Exception('Failed to load users');
    }
}
