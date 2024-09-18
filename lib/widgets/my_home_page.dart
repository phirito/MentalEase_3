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
                  child: LoginForm(apiService: _apiService, formKey: _formKey),
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
