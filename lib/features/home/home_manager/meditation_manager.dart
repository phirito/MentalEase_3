import 'package:hive_flutter/hive_flutter.dart';

class MeditationManager {
  bool _hasMeditatedToday = false;

  bool get hasMeditatedToday => _hasMeditatedToday;

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
  }

  Future<void> updateMeditationStatus() async {
    var box = await Hive.openBox('meditationBox');
    DateTime today = DateTime.now();
    await box.put('lastMeditationDate', today.toIso8601String());
    _hasMeditatedToday = true;
  }
}
