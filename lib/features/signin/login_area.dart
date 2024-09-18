import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/features/signup/signup_area.dart';
import 'package:mentalease_2/core/services/api_service.dart';

class LoginForm extends StatefulWidget {
  final ApiService apiService;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    Key? key,
    required this.apiService,
    required this.formKey,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAgreementChecked = false;

  void _login() async {
    if (widget.formKey.currentState!.validate() && _isAgreementChecked) {
      Map<String, dynamic> credentials = {
        'email': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      var response = await widget.apiService.signIn(credentials);

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeArea()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    } else if (!_isAgreementChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept the User Agreement to sign in.'),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: _usernameController,
            labelText: 'Username',
            icon: Icons.person,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: _passwordController,
            labelText: 'Password',
            icon: Icons.lock,
            obscureText: true,
          ),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Checkbox(
                value: _isAgreementChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreementChecked = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'I accept the User Agreement & Disclaimer',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed:
                _isAgreementChecked ? _login : null, // Disable if unchecked
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
                return SignUpArea();
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
        ],
      ),
    );
  }
}
