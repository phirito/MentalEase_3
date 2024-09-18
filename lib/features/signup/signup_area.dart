import 'package:flutter/material.dart';
import 'package:mentalease_2/core/utils/shared_widgets.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/core/services/api_service.dart'; // Import the ApiService

class SignUpArea extends StatefulWidget {
  // Change to StatefulWidget
  SignUpArea({super.key});

  @override
  _SignUpAreaState createState() => _SignUpAreaState();
}

class _SignUpAreaState extends State<SignUpArea> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers...
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _studIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Prepare user data
      Map<String, dynamic> userData = {
        'lname': _lnameController.text.trim(),
        'fname': _fnameController.text.trim(),
        'mname': _mnameController.text.trim(),
        'studID': _studIDController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      // Call the API
      var response = await _apiService.signUp(userData);

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
        title: const Text("Sign Up"),
        backgroundColor: const Color.fromARGB(255, 249, 251, 255),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              customTextFormField(
                controller: _lnameController,
                labelText: "Last Name",
                hintText: "Enter Last Name",
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _fnameController,
                labelText: "First Name",
                hintText: "Enter First Name",
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _mnameController,
                labelText: "Middle Name",
                hintText: "Enter Middle Name",
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your middle name';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _studIDController,
                labelText: "Student ID",
                hintText: "Enter Student ID",
                prefixIcon: Icons.school,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student ID';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _emailController,
                labelText: "Email",
                hintText: "Enter Email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "Enter password",
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                hintText: "Confirm password",
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _signup(context), // Pass context to _signup
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 107, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text("Sign-Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
