import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_area.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mentalease_2/features/signin/login_area.dart';

import '../core/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startFadeAnimation();
    _navigate();
  }

  _startFadeAnimation() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Delay before starting fade
    setState(() {
      _opacity = 1.0; // Start fading in
    });
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 3)); // Splash screen duration
    var box = Hive.box('appBox');
    bool? loggedIn = box.get('isLoggedIn', defaultValue: false);
    if (loggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeArea()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginForm(
            apiService: ApiServices(),
            formKey: GlobalKey<FormState>(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/images/mentalease_logo.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Text(
                'Mental Ease',
                style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
