import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mentalease_2/features/med_folder/meditation_session_page.dart';

class MeditateArea extends StatefulWidget {
  const MeditateArea({super.key, required this.updateMeditationStatus});

  final Function(bool) updateMeditationStatus;

  @override
  _MeditateAreaState createState() => _MeditateAreaState();
}

class _MeditateAreaState extends State<MeditateArea> {
  int _selectedDuration = 10; // Default duration
  List<Map<String, dynamic>> _sessionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSessionHistory(); // Load session history from Hive
  }

  void _completeSession() {
    final session = {
      'duration': _selectedDuration,
      'time': DateTime.now(),
    };

    setState(() {
      _sessionHistory.add(session);
    });

    _saveSessionHistory(); // Save the session to Hive
    widget.updateMeditationStatus(true);
  }

  void _increaseDuration() {
    setState(() => _selectedDuration += 30); // Increase by 30 seconds
  }

  void _decreaseDuration() {
    setState(() {
      if (_selectedDuration > 30) {
        _selectedDuration -=
            30; // Decrease by 30 seconds, minimum is 30 seconds
      }
    });
  }

  // Save session history to Hive
  void _saveSessionHistory() async {
    var box = Hive.box('sessionBox');
    await box.put('sessionHistory', _sessionHistory);
  }

  // Load session history from Hive
  void _loadSessionHistory() async {
    var box = Hive.box('sessionBox');
    final storedHistory = box.get('sessionHistory', defaultValue: []);
    setState(() {
      _sessionHistory = List<Map<String, dynamic>>.from(storedHistory);
    });
  }

  Widget _buildContainerButton(
      String title, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 116, 8, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizeDurationDialog() {
    // Customize duration logic
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildContainerButton(
          "Start Meditation",
          Icons.play_arrow,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MeditationSessionPage(
                selectedDuration: _selectedDuration,
                onComplete: _completeSession,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
