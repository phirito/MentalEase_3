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
    List<dynamic> rawHistory = box.get('sessionHistory', defaultValue: []);

    _sessionHistory = rawHistory.map<Map<String, dynamic>>((sessionData) {
      // Explicitly convert to Map<String, dynamic>
      Map<String, dynamic> session = Map<String, dynamic>.from(sessionData);
      return {
        'duration': session['duration'],
        'time': session['time'], // Keep 'time' as String
      };
    }).toList();

    // ignore: avoid_print
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

    // Ensure 'time' is a String
    Map<String, dynamic> sessionData = {
      'duration': session['duration'],
      'time': session['time'] is DateTime
          ? (session['time'] as DateTime).toIso8601String()
          : session['time'],
    };

    // Update local session history
    _sessionHistory.add(sessionData);

    // Save updated session history to Hive
    await box.put('sessionHistory', _sessionHistory);

    // ignore: avoid_print
    print("Session history saved: $_sessionHistory");
  }
}
