import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/onboarding_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      initialRoute: '/login',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('moodBox');
  await Hive.openBox('sessionBox');
  await Hive.openBox('meditationBox');
  await Hive.openBox('journalingBox');
  await Hive.openBox('toDoBox');
  await Hive.openBox('appData');

  runApp(const MyApp());
}
