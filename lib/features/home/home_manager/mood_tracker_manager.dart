import 'package:flutter/material.dart'; // Add this for BuildContext
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mentalease_2/core/services/api_service.dart';

class MoodTrackerManager {
  final Box moodBox = Hive.box('moodBox');
  final ApiServices apiServices = ApiServices();

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

  Future<void> loadMoodOfTheDay(String idNumber) async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _moodOfTheDay = box.get('moodOfTheDay_$today', defaultValue: '');

    // Load mood history from Hive
    _moodHistory = List<Map<String, dynamic>>.from(
      box.get('moodHistory', defaultValue: []),
    );

    // Fetch data from the server and update local storage
    await syncMoodHistoryFromServer(idNumber);
  }

  Future<void> updateMoodOfTheDay(
      String selectedMood, String idNumber, BuildContext context) async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    await box.put('moodOfTheDay_$today', selectedMood);
    _moodOfTheDay = selectedMood;

    // Add the selected mood to the mood history with a timestamp
    String now = DateTime.now().toIso8601String();
    _moodHistory.add({
      'mood': selectedMood,
      'date': now,
    });

    // Save the updated mood history locally
    await box.put('moodHistory', _moodHistory);

    // Send the mood data to the server
    try {
      await apiServices.updateMoodForUser(
          context, idNumber, today, selectedMood);
    } catch (e) {
      print("Error updating mood on server: $e");
    }
  }

  Future<void> syncMoodHistoryFromServer(String idNumber) async {
    try {
      // Fetch the mood history from the server for the logged-in user
      Map<String, dynamic> moodData =
          await apiServices.getMoodHistory(idNumber);

      // Update the local Hive storage with data from the server
      for (String day in moodData.keys) {
        moodBox.put(day, moodData[day]);
      }

      // Update _moodHistory based on the fetched server data
      _moodHistory = moodData.entries
          .map((entry) => {'mood': entry.value, 'date': entry.key})
          .toList();
    } catch (e) {
      print("Error syncing mood history from server: $e");
    }
  }

  String? getMood(String date) {
    return moodBox.get(date);
  }

  String getMoodHistoryAsString() {
    if (_moodHistory.isEmpty) {
      return 'No mood history available.';
    }

    String moodHistoryText = 'My Mood History:\n';
    for (var entry in _moodHistory) {
      String dateTime = entry['date'];
      String mood = entry['mood'];
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
}
