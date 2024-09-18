import 'package:shared_preferences/shared_preferences.dart';

class MeditationManager {
  bool _hasMeditatedToday = false;

  bool get hasMeditatedToday => _hasMeditatedToday;

  Future<void> checkMeditationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastMeditationDate = prefs.getString('lastMeditationDate');

    if (lastMeditationDate != null) {
      DateTime lastMeditation = DateTime.parse(lastMeditationDate);
      DateTime today = DateTime.now();

      _hasMeditatedToday = (lastMeditation.year == today.year &&
          lastMeditation.month == today.month &&
          lastMeditation.day == today.day);
    } else {
      _hasMeditatedToday = false;
    }
  }

  Future<void> updateMeditationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    await prefs.setString('lastMeditationDate', today.toIso8601String());
    _hasMeditatedToday = true;
  }
}
