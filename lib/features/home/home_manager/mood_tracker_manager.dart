import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MoodTrackerManager {
  final Box moodBox = Hive.box('moodBox');
  String _moodOfTheDay = '';
  String get moodOfTheDay => _moodOfTheDay;
  List<Map<String, dynamic>> _moodHistory = [];
  List<Map<String, dynamic>> get moodHistory => _moodHistory;

  List<Map<String, dynamic>> getMoodHistoryForCarousel() {
    return _moodHistory.reversed.take(3).toList();
  }

  List<Map<String, dynamic>> getAllMoodHistory() {
    return _moodHistory;
  }

  Map<String, int> getMoodStats() {
    Map<String, int> moodStats = {
      'Happy': 0,
      'Neutral': 0,
      'Sad': 0,
      'Angry': 0,
      'Anxious': 0,
      'Tired': 0,
    };

    for (var entry in _moodHistory) {
      String mood = entry['mood'];
      moodStats[mood] = (moodStats[mood] ?? 0) + 1;
    }

    return moodStats;
  }

  Map<String, String> getMoodHistory() {
    final keys = moodBox.keys.cast<String>();
    final Map<String, String> moodHistory = {};
    for (String key in keys) {
      moodHistory[key] = moodBox.get(key);
    }
    return moodHistory;
  }

  Future<void> loadMoodOfTheDay() async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _moodOfTheDay = box.get('moodOfTheDay_$today', defaultValue: '');

    // Load mood history from Hive
    _moodHistory = List<Map<String, dynamic>>.from(
        box.get('moodHistory', defaultValue: []));
  }

  Future<void> updateMoodOfTheDay(String selectedMood) async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await box.put('moodOfTheDay_$today', selectedMood);
    _moodOfTheDay = selectedMood;

    // Add the selected mood to the mood history with a timestamp
    String now = DateTime.now().toIso8601String();
    _moodHistory.add({
      'mood': selectedMood,
      'date': now,
    });

    // Save the updated mood history
    await box.put('moodHistory', _moodHistory);
  }

  String? getMood(String date) {
    return moodBox.get(date);
  }

  // Function to get mood statistics for the graph
  String getMoodHistoryAsString() {
    if (_moodHistory.isEmpty) {
      return 'No mood history available.';
    }

    String moodHistoryText = 'My Mood History:\n';
    for (var entry in _moodHistory) {
      String dateTime = entry['date'];
      String mood = entry['mood'];
      // Format the date and time for readability
      DateTime parsedDate = DateTime.parse(dateTime);
      String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
      moodHistoryText += '$formattedDate: $mood\n';
    }
    return moodHistoryText;
  }

  void setMood(String date, String mood) {
    moodBox.put(date, mood);
  }
  // Existing methods (e.g., getMoodStats) remain unchanged...
}
