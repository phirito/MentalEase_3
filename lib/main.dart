// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/splash_screen.dart';
import 'widgets/onboarding_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  _checkFirstTime() async {
    var box = Hive.box('appBox');
    bool? firstTime = box.get('isFirstTime', defaultValue: true);
    setState(() {
      _isFirstTime = firstTime!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Ease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isFirstTime ? OnboardingScreen() : SplashScreen(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('moodBox');
  await Hive.openBox('moodHistory');
  await Hive.openBox('sessionBox');
  await Hive.openBox('meditationBox');
  await Hive.openBox('journalingBox');
  await Hive.openBox('toDoBox');
  await Hive.openBox('appBox');

  runApp(MyApp());
}
