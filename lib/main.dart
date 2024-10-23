import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthManager {
  static Future<void> checkAuthState(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      initialRoute: '/',
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kttfbppexbekdvqnappa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0dGZicHBleGJla2R2cW5hcHBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk1NjM0NDAsImV4cCI6MjA0NTEzOTQ0MH0.04oo82gtbc55ckxC4CyYZCNxJZlW6HRHTVCXokmkArc',
  );

  await Hive.initFlutter();
  await Hive.openBox('moodBox');
  await Hive.openBox('sessionBox');
  await Hive.openBox('meditationBox');
  await Hive.openBox('journalingBox');
  await Hive.openBox('toDoBox');
  await Hive.openBox('appData');

  runApp(const MyApp());
}
