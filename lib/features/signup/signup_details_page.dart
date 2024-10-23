// file: signup_details_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/widgets/shared_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpDetailsPage extends StatefulWidget {
  final ApiService apiService;
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
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _yearlvlController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;

  // New variable to store the selected date
  DateTime? _selectedDate;

  void _completeSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final Map<String, dynamic> userData = {
          'id_number': widget.idNumber,
          'last_name': _lnameController.text.trim(),
          'first_name': _fnameController.text.trim(),
          'middle_name': _mnameController.text.trim(),
          'year_level': _yearlvlController.text.trim(),
          'birth_date': _selectedDate?.toIso8601String(), // Save as ISO string
          'gender': _selectedGender,
        };

        // Insert into 'users' table using ApiService
        await widget.apiService.insertUserData(userData);

        // Insertion succeeded
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up completed successfully.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeArea()),
        );
      } catch (e) {
        // Handle exceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save details: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Form validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details.')),
      );
    }
  }

  // New method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        DateTime.now().subtract(const Duration(days: 365 * 15)); // 15 years ago
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Format the selected date and set it to the controller
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
              // ... [Other form fields remain unchanged]
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
                controller: _mnameController,
                labelText: "Middle Name",
                hintText: "Enter Middle Name",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your middle name';
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
              // Birthdate field with date picker
              TextFormField(
                controller: _birthdateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Birthdate",
                  hintText: "Select your birthdate",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your birthdate';
                  }
                  return null;
                },
              ),
              vSpacer(10),
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
                      child: const Text(
                        "Complete Sign-Up",
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
