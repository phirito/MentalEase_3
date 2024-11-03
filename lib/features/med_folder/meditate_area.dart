//meditate_area.dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mentalease_2/features/med_folder/meditation_session_screen.dart';
import 'package:mentalease_2/features/med_folder/session_history_screen.dart';
import 'package:mentalease_2/features/home/home_manager/meditation_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditateArea extends StatefulWidget {
  const MeditateArea({super.key, required this.updateMeditationStatus});

  final Function(bool) updateMeditationStatus;

  @override
  _MeditateAreaState createState() => _MeditateAreaState();
}

class _MeditateAreaState extends State<MeditateArea> {
  final MeditationManager _meditationManager = MeditationManager();
  int _selectedDuration = 600; // Default duration in seconds (10 minutes)
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
              style: GoogleFonts.quicksand(fontSize: 18, color: Colors.white),
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
        Duration tempDuration = Duration(seconds: _selectedDuration);
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: SizedBox(
            height: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Customize Duration",
                    style: GoogleFonts.quicksand(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.ms,
                    initialTimerDuration: tempDuration,
                    onTimerDurationChanged: (Duration newDuration) {
                      setState(() {
                        tempDuration = newDuration;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.quicksand(
                            color: const Color.fromARGB(255, 194, 194, 194)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDuration = tempDuration.inSeconds;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        "OK",
                        style: GoogleFonts.quicksand(
                            color: const Color.fromARGB(255, 114, 0, 0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  Widget buildMeditationHistory() {
    if (_sessionHistory.isEmpty) {
      return Text(
        'No meditation sessions recorded',
        style: GoogleFonts.quicksand(),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _sessionHistory.length,
      itemBuilder: (context, index) {
        final session = _sessionHistory[index];
        DateTime time = DateTime.parse(session['time']);
        return ListTile(
          title: Text(
            'Duration: ${Duration(seconds: session['duration']).inMinutes} minutes',
            style: GoogleFonts.quicksand(),
          ),
          subtitle:
              Text('Time: ${time.toString()}', style: GoogleFonts.quicksand()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display the selected duration in minutes and seconds
    final selectedMinutes = _selectedDuration ~/ 60;
    final selectedSeconds = _selectedDuration % 60;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/meditation_img.png',
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Text(
              'Selected Duration: $selectedMinutes min $selectedSeconds sec',
              style: GoogleFonts.quicksand(fontSize: 16),
            ),
            const SizedBox(height: 10),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Tip: To meditate effectively, find a quiet spot, sit comfortably, and focus on your breathing. Let your thoughts pass without dwelling on them.",
                  style:
                      GoogleFonts.quicksand(fontSize: 14, color: Colors.grey),
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
