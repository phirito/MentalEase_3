import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/features/signup/signup_area.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/widgets/user_agreement.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.logo, required this.title});

  final Widget logo;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAgreementChecked = false;

  void _login() async {
    if (_formKey.currentState!.validate() && _isAgreementChecked) {
      Map<String, dynamic> credentials = {
        'email': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      var response = await _apiService.signIn(credentials);

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
            content: Text('You must accept the User Agreement to sign in.')),
      );
    }
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Image.asset(
                    "assets/images/mentalease_logo.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                const UserAgreementPage(),
                Container(
                  width: 320,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 249, 251, 255),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(104, 121, 121, 121)
                            .withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _buildLoginForm(), // Add login form here
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeArea();
                    }));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Continue as Guest",
                    style: TextStyle(color: Color.fromARGB(255, 116, 8, 0)),
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
