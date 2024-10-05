import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditateTimer extends StatefulWidget {
  final int selectedDuration;
  final Function onComplete;

  const MeditateTimer({
    super.key,
    required this.selectedDuration,
    required this.onComplete,
  });

  @override
  _MeditateTimerState createState() => _MeditateTimerState();
}

class _MeditateTimerState extends State<MeditateTimer>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;
  bool _sessionCompleted = false;
  late AnimationController _controller;
  late Animation<double> _breathingAnimation;
  String _breathingText = "Inhale";
  String? _selectedMusicPath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      setState(() {
        _breathingText =
            status == AnimationStatus.forward ? "Inhale" : "Exhale";
      });
    });
  }

  void _startTimer() {
    if (_sessionCompleted) return; // Prevent starting if session completed
    setState(() => _isRunning = !_isRunning);
    if (_isRunning) {
      _controller.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _start++;
          if (_start >= widget.selectedDuration) {
            _sessionCompleted = true;
            _isRunning = false;
            _controller.stop();
            _timer?.cancel();
            _audioPlayer.stop();
            widget.onComplete();
          }
        });
      });
      if (_selectedMusicPath != null) {
        _audioPlayer.play(DeviceFileSource(_selectedMusicPath!));
      }
    } else {
      _pauseTimer();
    }
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _controller.stop();
    _timer?.cancel();
    _audioPlayer.pause();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _sessionCompleted = false;
      _start = 0;
      _audioPlayer.stop();
    });
    _controller.reset();
    _timer?.cancel();
  }

  Future<void> _selectMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedMusicPath = result.files.single.path;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate remaining time
    final remainingTime = widget.selectedDuration - _start;
    final minutes = remainingTime ~/ 60;
    final seconds = remainingTime % 60;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Breathing Animation and Timer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _breathingAnimation.value,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 116, 0, 0)
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  "$minutes:${seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Breathing Instruction or Completion Message
          Text(
            _sessionCompleted
                ? "Great job completing your meditation!"
                : _isRunning
                    ? _breathingText
                    : "Press Start to Meditate",
            style: const TextStyle(fontSize: 24, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          // Control Buttons
          if (!_sessionCompleted)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color.fromARGB(255, 116, 0, 0),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                // Reset Button
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          else
            // Session Completed Options
            Column(
              children: [
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 0, 0),
                  ),
                  child: const Text(
                    "Restart Session",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 30),
          // Music Selection Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  onPressed: _selectMusic,
                  icon: const Icon(Icons.music_note),
                  tooltip: "Select Music",
                  iconSize: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
