import 'package:flutter/material.dart';
import 'package:mentalease_2/core/utils/shared_widgets.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/core/services/api_service.dart'; // Import the ApiService

class LoginArea extends StatefulWidget {
  // Change to StatefulWidget
  const LoginArea({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginAreaState createState() => _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers...
  final TextEditingController _usernameController =
      TextEditingController(); // Optional, if needed
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Prepare credentials
      Map<String, dynamic> credentials = {
        'email': _usernameController.text
            .trim(), // Assuming email is used as username
        'password': _passwordController.text.trim(),
      };

      // Call the API
      var response = await _apiService.signIn(credentials);

      if (!mounted) return; // Check if the widget is still in the widget tree

      if (response['status'] == 'success') {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        // Navigate to HomeArea
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeArea()),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign-In"),
        backgroundColor: const Color.fromARGB(255, 116, 8, 0),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  icon: Icons.person,
                ),
                const SizedBox(height: 16.0),
                buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    iconColor:
                        const Color.fromARGB(255, 116, 8, 0), // Button color
                    backgroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 116, 8, 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
