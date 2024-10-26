import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/features/signin/login_area.dart'; // Import for login
import 'package:mentalease_2/widgets/shared_widgets.dart';

class SignUpDetailsPage extends StatefulWidget {
  final ApiServices apiService; // Updated to ApiServices
  final String idNumber;

  const SignUpDetailsPage({
    Key? key,
    required this.apiService,
    required this.idNumber,
  }) : super(key: key);

  @override
  _SignUpDetailsPageState createState() => _SignUpDetailsPageState();
}

class _SignUpDetailsPageState extends State<SignUpDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _yearlvlController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;

  // Function to complete the signup process and send data to the backend
  void _completeSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var url = Uri.parse(
            'https://mentalease.ccsdepartment.com/MentalEase_Database/users_account/users_api.php');
        var response = await http.post(url, body: {
          'action': 'complete_signup', // Action to trigger complete signup
          'id_number': widget.idNumber,
          'first_name': _fnameController.text.trim(),
          'last_name': _lnameController.text.trim(),
          'year_level': _yearlvlController.text.trim(),
          'gender': _selectedGender, // Include gender
        });

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Details saved successfully. Admin will review your account.'),
                duration: Duration(seconds: 8),
              ),
            );

            // Redirect to login page after successful signup
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginForm(
                    apiService: ApiService(), // Pass the ApiService instance
                    formKey: GlobalKey<FormState>(), // Redirect to LoginForm
                  ),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to save details: ${data['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Server error. Please try again later.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Additional Details"),
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
                  width: 100,
                  height: 100,
                ),
              ),
              customTextFormField(
                controller: _lnameController,
                labelText: "Last Name",
                hintText: "Enter Last Name",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
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
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              vSpacer(10),
              customTextFormField(
                controller: _yearlvlController,
                labelText: "Year Level",
                hintText: "Enter Year Level [7-10]",
                prefixIcon: Icons.school,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your year level';
                  } else if (!RegExp(r'^[7-9]|10$').hasMatch(value)) {
                    return 'Please enter a valid year level (7-10)';
                  }
                  return null;
                },
              ),
              vSpacer(10),

              // Gender Dropdown Field
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: "Gender",
                  prefixIcon: const Icon(Icons.wc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male"),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female"),
                  ),
                  DropdownMenuItem(
                    value: "Other",
                    child: Text("Other"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _completeSignUp(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 97, 0, 0),
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 5),
                      ),
                      child: const Text("Complete Sign-Up"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
