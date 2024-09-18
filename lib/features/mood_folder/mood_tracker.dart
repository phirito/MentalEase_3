import 'package:flutter/material.dart';
import 'package:mentalease_2/features/mood_folder/widgets/greeting_widget.dart';
import 'package:mentalease_2/features/mood_folder/widgets/mood_display.dart';
import 'package:mentalease_2/features/mood_folder/widgets/mood_history.dart';
import 'package:mentalease_2/features/mood_folder/widgets/mood_selection_grid.dart';
import 'package:mentalease_2/widgets/container_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class MoodTracker extends StatefulWidget {
  final bool showGreeting;
  final Function(String) updateMoodOfTheDay;

  const MoodTracker({
    super.key,
    this.showGreeting = true,
    required this.updateMoodOfTheDay,
  });

  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  String _selectedMood = '';
  String _moodOfTheDay = '';
  final List<Map<String, String>> _moods = [
    {'emoji': '😀', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😞', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  final List<String> _moodHistory = ['Happy', 'Sad', 'Neutral'];

  @override
  void initState() {
    super.initState();
    _loadMoodOfTheDay(); // Load saved mood when the page is opened
  }

  void _addMoodToHistory(String mood) {
    if (_moodHistory.length >= 3) {
      _moodHistory.removeAt(0);
    }
    _moodHistory.add(mood);
  }

  Future<void> _saveMoodOfTheDay(String mood) async {
    final prefs = await SharedPreferences.getInstance();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Save mood and today's date
    await prefs.setString('moodOfTheDay', mood);
    await prefs.setString('moodDate', today);

    // Update the state
    setState(() {
      _moodOfTheDay = mood;
    });
  }

  Future<void> _loadMoodOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedMood = prefs.getString('moodOfTheDay');
    String? savedDate = prefs.getString('moodDate');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if mood has already been selected for today
    if (savedMood != null && savedDate == today) {
      setState(() {
        _moodOfTheDay = savedMood;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showGreeting) GreetingWidget(mediaQuery: mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.02),
              MoodSelectionGrid(
                mediaQuery: mediaQuery,
                isLandscape: isLandscape,
                moods: _moods,
                selectedMood: _selectedMood,
                onMoodSelected: _handleMoodSelection,
                moodOfTheDay: _moodOfTheDay,
              ),
              SizedBox(height: mediaQuery.size.height * 0.02),
              MoodDisplay(moodOfTheDay: _moodOfTheDay, mediaQuery: mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.05),
              ContainerButton(
                mediaQuery: mediaQuery,
                onTap: () => _showMoodHistoryDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMoodSelection(String moodLabel, bool selected) {
    if (_moodOfTheDay.isEmpty) {
      setState(() {
        _selectedMood = selected ? moodLabel : '';
        if (selected) {
          _saveMoodOfTheDay(moodLabel); // Save the mood for today
          widget.updateMoodOfTheDay(moodLabel);
          _addMoodToHistory(moodLabel);
        }
      });
    }
  }

  void _showMoodHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mood History (Last 3 Days)"),
          content: MoodHistoryChart(
            mediaQuery: MediaQuery.of(context),
            moods: _moods,
            moodHistory: _moodHistory,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MoodTracker(
      updateMoodOfTheDay: (mood) {},
    ),
  ));
}
