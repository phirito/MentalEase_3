import 'package:flutter/material.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/widgets/shared_widgets.dart';
import 'package:mentalease_2/features/home/home_area.dart';

class SignUpDetailsPage extends StatefulWidget {
  final ApiService apiService;

  const SignUpDetailsPage({super.key, required this.apiService});

  @override
  _SignUpDetailsPageState createState() => _SignUpDetailsPageState();
}

class _SignUpDetailsPageState extends State<SignUpDetailsPage> {
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _mnameController = TextEditingController();
  String? _selectedGender;

  void _completeSignUp(BuildContext context) {
    if (_lnameController.text.isNotEmpty &&
        _fnameController.text.isNotEmpty &&
        _mnameController.text.isNotEmpty &&
        _selectedGender != null) {
      // Complete sign-up and navigate to HomeArea
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-up completed successfully.')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeArea()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details.')),
      );
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
            ElevatedButton(
              onPressed: () => _completeSignUp(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 107, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("Complete Sign-Up"),
            ),
          ],
        ),
      ),
    );
  }
}
