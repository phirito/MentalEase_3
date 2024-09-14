// mood_tracker_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class MoodTrackerManager {
  String _moodOfTheDay = '';

  String get moodOfTheDay => _moodOfTheDay;

  Future<void> loadMoodOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _moodOfTheDay = prefs.getString('moodOfTheDay') ?? '';
  }

  Future<void> updateMoodOfTheDay(String selectedMood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('moodOfTheDay', selectedMood);
    _moodOfTheDay = selectedMood;
  }
}
