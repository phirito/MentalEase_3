import 'package:flutter/material.dart';
import 'package:mentalease_2/features/med_folder/meditation_session_page.dart';
import 'package:mentalease_2/features/med_folder/session_history_page.dart';

class MeditateArea extends StatefulWidget {
  const MeditateArea({super.key, required this.updateMeditationStatus});

  final Function(bool) updateMeditationStatus;

  @override
  _MeditateAreaState createState() => _MeditateAreaState();
}

class _MeditateAreaState extends State<MeditateArea> {
  int _selectedDuration = 10; // Default duration
  final List<Map<String, dynamic>> _sessionHistory = [];

  void _completeSession() {
    setState(() {
      _sessionHistory.add({
        'duration': _selectedDuration,
        'time': DateTime.now(),
      });
    });

    widget.updateMeditationStatus(true);
  }

  void _increaseDuration() {
    setState(() => _selectedDuration += 10);
  }

  void _decreaseDuration() {
    setState(() {
      if (_selectedDuration > 10) _selectedDuration -= 10;
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Customize Duration"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adjust the meditation duration:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: _decreaseDuration,
                    tooltip: "Decrease Time",
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '${_selectedDuration ~/ 60} min ${_selectedDuration % 60} sec',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: _increaseDuration,
                    tooltip: "Increase Time",
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToSessionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeditationSessionPage(
          selectedDuration: _selectedDuration,
          onComplete: _completeSession,
        ),
      ),
    );
  }

  void _navigateToSessionHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SessionHistoryPage(sessionHistory: _sessionHistory),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the image at the top
            Image.asset(
              'assets/images/meditation_img.png', // Path to the image
              height: 200,
              width: 300,
              fit: BoxFit.cover, // Adjust the image to cover the area
            ),
            const SizedBox(height: 20), // Add some spacing after the image
            _buildContainerButton(
              "Customize Time",
              Icons.timer,
              _showCustomizeDurationDialog,
            ),
            _buildContainerButton(
              "Start Meditation",
              Icons.play_arrow,
              _navigateToSessionPage,
            ),
            _buildContainerButton(
              "Session History",
              Icons.history,
              _navigateToSessionHistoryPage,
            ),
            const SizedBox(height: 40), // Space between buttons and tip
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tip: To meditate effectively, find a quiet spot, sit comfortably, and focus on your breathing. Let your thoughts pass without dwelling on them.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
