import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/features/signin/forgotpass.dart';
import 'package:mentalease_2/features/signup/signup_area.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/widgets/shared_widgets.dart';

class LoginForm extends StatefulWidget {
  final ApiServices apiService; // Use `ApiServices` for users' API
  final GlobalKey<FormState> formKey;

  LoginForm({
    Key? key,
    required this.apiService,
    required this.formKey,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add a state variable to track password visibility
  bool _isPasswordVisible = false;

  void _login() async {
    if (widget.formKey.currentState!.validate()) {
      // Use id_number for login
      var response = await widget.apiService.signIn(
        _idNumberController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        // Navigate to the dashboard (home_area.dart) after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeArea(),
          ),
        );
      } else {
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
        title: Text(
          "Login",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                controller: _idNumberController,
                labelText: 'ID Number',
                hintText: 'Enter your ID number',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Password field with eye icon for visibility toggle
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
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
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Color.fromARGB(255, 116, 8, 0)),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SignUpArea();
                  }));
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Sign-Up",
                  style: TextStyle(color: Color.fromARGB(255, 116, 8, 0)),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ForgotPasswordPage();
                  }));
                },
                style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 116, 8, 0)),
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
