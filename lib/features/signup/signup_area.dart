import 'package:flutter/material.dart';
import 'package:mentalease_2/widgets/shared_widgets.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/features/signup/signup_details_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpArea extends StatefulWidget {
  const SignUpArea({super.key});

  @override
  _SignUpAreaState createState() => _SignUpAreaState();
}

class _SignUpAreaState extends State<SignUpArea> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers...
  final TextEditingController _studIDController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Method to check if the student ID exists in the database
  Future<bool> _isStudentInDatabase(String studentID) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id_number')
          .eq('id_number', studentID)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking student ID: $e');
      return false;
    }
  }

  void _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      bool isStudentInDB =
          await _isStudentInDatabase(_studIDController.text.trim());

      if (!isStudentInDB) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Student ID not found in the database.')),
        );
        return; // Stop further processing if student ID is not found
      }

      try {
        // Proceed with email sign-up
        final AuthResponse response =
            await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: '', // Optionally, handle password input as needed
        );
        if (response.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Sign-Up successful! Please verify your email.')),
          );

          if (response.user!.emailConfirmedAt != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpDetailsPage(
                  apiService: _apiService,
                  idNumber: _studIDController.text.trim(),
                ),
              ),
            );
          }
        } else {
          // Sign-Up failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Sign-Up failed. Please try again later.')),
          );
        }
      } catch (e) {
        // Handle unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Image.asset(
                  "assets/images/mentalease_logo.png",
                  width: 200,
                  height: 200,
                ),
              ),
              customTextFormField(
                controller: _studIDController,
                labelText: "Student ID",
                hintText: "Enter Student ID",
                prefixIcon: Icons.school,
                keyboardType: TextInputType.text, // Changed to text
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
              ElevatedButton(
                onPressed: () => _signup(context), // Pass context to _signup
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 97, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                ),
                child: const Text(
                  "Sign-Up",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
