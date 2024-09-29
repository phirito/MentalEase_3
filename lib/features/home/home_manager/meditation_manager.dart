import 'package:hive_flutter/hive_flutter.dart';

class MeditationManager {
  bool _hasMeditatedToday = false;
  List<Map<String, dynamic>> _sessionHistory = [];

  bool get hasMeditatedToday => _hasMeditatedToday;
  List<Map<String, dynamic>> get sessionHistory => _sessionHistory;

  Future<void> checkMeditationStatus() async {
    var box = await Hive.openBox('meditationBox');
    String? lastMeditationDate = box.get('lastMeditationDate');

    if (lastMeditationDate != null) {
      DateTime lastMeditation = DateTime.parse(lastMeditationDate);
      DateTime today = DateTime.now();

      _hasMeditatedToday = (lastMeditation.year == today.year &&
          lastMeditation.month == today.month &&
          lastMeditation.day == today.day);
    } else {
      _hasMeditatedToday = false;
    }

    // Load session history from Hive
    _sessionHistory = List<Map<String, dynamic>>.from(
            box.get('sessionHistory', defaultValue: []))
        .map((session) => {
              'duration': session['duration'],
              'time': session['time'] is String
                  ? DateTime.parse(session['time'])
                  : session['time'],
            })
        .toList();

    print("Session history loaded: $_sessionHistory");
  }

  Future<void> updateMeditationStatus() async {
    var box = await Hive.openBox('meditationBox');
    DateTime today = DateTime.now();
    await box.put('lastMeditationDate', today.toIso8601String());
    _hasMeditatedToday = true;
  }

  // Save session history to Hive
  Future<void> saveSessionHistory(Map<String, dynamic> session) async {
    var box = await Hive.openBox('meditationBox');
    _sessionHistory.add(session);
    await box.put('sessionHistory', _sessionHistory);

    print("Session history saved: $_sessionHistory");
  }
}
