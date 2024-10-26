import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:mentalease_2/features/signin/login_area.dart';
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
  bool _isAgreementChecked = false; // Checkbox state management

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
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreementChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAgreementChecked = value ?? false;
                          if (_isAgreementChecked) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginForm(
                                  apiService: ApiServices(), formKey: _formKey);
                            }));
                          }
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I accept the Disclaimer & User Agreement ',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomeArea();
                    }));
                  },
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
