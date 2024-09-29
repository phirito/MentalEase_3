import 'package:flutter/material.dart';
import 'package:mentalease_2/features/med_folder/meditation_session_page.dart';
import 'package:mentalease_2/features/med_folder/session_history_page.dart';
import 'package:mentalease_2/features/home/home_manager/meditation_manager.dart';

class MeditateArea extends StatefulWidget {
  const MeditateArea({super.key, required this.updateMeditationStatus});

  final Function(bool) updateMeditationStatus;

  @override
  _MeditateAreaState createState() => _MeditateAreaState();
}

class _MeditateAreaState extends State<MeditateArea> {
  final MeditationManager _meditationManager = MeditationManager();
  int _selectedDuration = 10; // Default duration
  List<Map<String, dynamic>> _sessionHistory = [];

  @override
  void initState() {
    super.initState();

    _loadSessionHistory(); // Load the meditation status and session history
  }

  // Load session history from MeditationManager
  Future<void> _loadSessionHistory() async {
    await _meditationManager.checkMeditationStatus();
    setState(() {
      _sessionHistory = _meditationManager.sessionHistory;
    }); // Refresh UI once data is loaded
  }

  // Complete meditation session
  void _completeSession() async {
    final session = {
      'duration': _selectedDuration,
      'time': DateTime.now().toIso8601String(),
    };

    // Save session to history and update status
    await _meditationManager.saveSessionHistory(session);
    await _loadSessionHistory(); // Reload the updated session history
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
        return StatefulBuilder(
          // Use StatefulBuilder to manage state within the dialog
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Customize Duration"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setStateDialog(() {
                            // Use setStateDialog to update the dialog's state
                            _decreaseDuration();
                          });
                        },
                      ),
                      Text(
                          "${_selectedDuration ~/ 60} min ${_selectedDuration % 60} sec"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setStateDialog(() {
                            // Use setStateDialog to update the dialog's state
                            _increaseDuration();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Color.fromARGB(255, 128, 0, 0)),
                  ),
                ),
              ],
            );
          },
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

  Widget _buildMeditationHistory() {
    if (_sessionHistory.isEmpty) {
      return const Text('No meditation sessions recorded');
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _sessionHistory.length,
      itemBuilder: (context, index) {
        final session = _sessionHistory[index];
        return ListTile(
          title: Text('Duration: ${session['duration']} minutes'),
          subtitle: Text('Time: ${session['time'].toString()}'),
        );
      },
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
