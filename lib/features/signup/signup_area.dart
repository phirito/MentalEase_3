import 'package:flutter/material.dart';
import 'package:mentalease_2/widgets/shared_widgets.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/features/signup/signup_details_page.dart';

class SignUpArea extends StatefulWidget {
  const SignUpArea({super.key});

  @override
  _SignUpAreaState createState() => _SignUpAreaState();
}

class _SignUpAreaState extends State<SignUpArea> {
  final _formKey = GlobalKey<FormState>();
  final ApiServices _apiServices = ApiServices(); // Use the ApiServices class

  // Controllers for the input fields
  final TextEditingController _idnumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Track the visibility of the password
  bool _isPasswordVisible = false;

  // Function to handle sign-up logic
  void _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Call the ApiServices signUp method
        var response = await _apiServices.signUp(
          _idnumberController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // Handle the response
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Sign-Up successful! Your account is pending admin approval.'),
              duration: Duration(seconds: 8),
            ),
          );

          // Navigate to the next page after successful registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpDetailsPage(
                apiService: _apiServices,
                idNumber: _idnumberController.text.trim(),
              ),
            ),
          );
        } else {
          // If the sign-up fails, show the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-Up failed: ${response['message']}')),
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
                controller: _idnumberController,
                labelText: "Student ID",
                hintText: "Enter Student ID",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student id';
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
              TextFormField(
                controller: _passwordController,
                obscureText:
                    !_isPasswordVisible, // Toggle obscureText based on visibility
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              ElevatedButton(
                onPressed: () => _signup(context), // Call the signup function
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
