import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MeditateArea extends StatefulWidget {
  const MeditateArea({super.key, required this.updateMeditationStatus});

  // Callback to notify HomeArea when a session is completed
  final Function(bool) updateMeditationStatus;

  @override
  // ignore: library_private_types_in_public_api
  _MeditateAreaState createState() => _MeditateAreaState();
}

class _MeditateAreaState extends State<MeditateArea>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;
  // ignore: unused_field
  int _completedSessions = 0;
  int _selectedDuration = 10; // Default duration set to 10 seconds
  late AnimationController _controller;
  late Animation<double> _breathingAnimation;
  String _breathingText = "Inhale"; // Breathing text state

  // List to store session history
  final List<Map<String, dynamic>> _sessionHistory = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 6), // 6 seconds for full breathing cycle
    );

    // Breathing animation setup (expansion and contraction)
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Listen to the animation status to update the breathing text
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          _breathingText = "Inhale";
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          _breathingText = "Exhale";
        });
      }
    });
  }

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _controller.repeat(
        reverse: true); // Loop the breathing animation for inhale and exhale
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _start++;
        if (_start >= _selectedDuration) {
          _completeSession(); // Trigger when selected time is reached
        }
      });
    });
  }

  void _completeSession() async {
    _resetTimer();
    setState(() {
      _completedSessions++; // Increment the completed session count

      // Add a new entry to session history
      _sessionHistory.add({
        'duration': _selectedDuration,
        'time': DateTime.now(),
      });
    });

    // Store today's date in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastMeditationDate', DateTime.now().toIso8601String());

    // Notify HomeArea that meditation is complete
    widget.updateMeditationStatus(true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Congratulations! Session completed.")),
    );
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _isRunning = false;
    _controller.stop();
    _timer?.cancel();
  }

  void _resetTimer() {
    _isRunning = false;
    _controller.reset();
    _timer?.cancel();
    setState(() {
      _start = 0;
    });
  }

  void _increaseDuration() {
    setState(() {
      _selectedDuration += 10;
    });
  }

  void _decreaseDuration() {
    setState(() {
      if (_selectedDuration > 10) {
        _selectedDuration -= 10;
      }
    });
  }

  Widget _buildSessionHistory() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _sessionHistory.length,
      itemBuilder: (context, index) {
        var session = _sessionHistory[index];
        var durationMinutes = session['duration'] ~/ 60;
        var durationSeconds = session['duration'] % 60;
        var time = session['time'] as DateTime;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$durationMinutes min $durationSeconds sec",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${time.hour}:${time.minute.toString().padLeft(2, '0')} on ${time.day}/${time.month}/${time.year}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Customize Meditation Duration:',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: _decreaseDuration,
                  tooltip: "Decrease Time",
                ),
                Text(
                  '${_selectedDuration ~/ 60} min ${_selectedDuration % 60} sec',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _increaseDuration,
                  tooltip: "Increase Time",
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathingAnimation.value,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  "${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  tooltip: 'Start',
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _pauseTimer,
                  icon: const Icon(Icons.pause),
                  tooltip: 'Pause',
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Reset',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isRunning ? _breathingText : "Press Start to Meditate",
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              "Meditation History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _sessionHistory.isEmpty
                  ? const Text("No sessions completed yet.")
                  : _buildSessionHistory(),
            ),
          ],
        ),
      ),
    );
  }
}
