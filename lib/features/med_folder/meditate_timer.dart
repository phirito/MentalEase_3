import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditateTimer extends StatefulWidget {
  final int selectedDuration;
  final Function onComplete;

  const MeditateTimer(
      {super.key, required this.selectedDuration, required this.onComplete});

  @override
  _MeditateTimerState createState() => _MeditateTimerState();
}

class _MeditateTimerState extends State<MeditateTimer>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _start = 0;
  bool _isRunning = false;
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
    if (_isRunning) return;
    setState(() => _isRunning = true);
    _controller.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _start++;
        if (_start >= widget.selectedDuration) {
          widget.onComplete();
          _resetTimer();
        }
      });
    });

    if (_selectedMusicPath != null) {
      _audioPlayer.play(DeviceFileSource(_selectedMusicPath!));
    }
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    setState(() => _isRunning = false);
    _controller.stop();
    _timer?.cancel();
    _audioPlayer.pause();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
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
    return Stack(
      children: [
        Column(
          children: [
            Stack(
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
                  "${_start ~/ 60}:${(_start % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 48),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _startTimer,
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 30,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _pauseTimer,
                  icon: const Icon(Icons.pause),
                  iconSize: 30,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isRunning ? _breathingText : "Press Start to Meditate",
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 200),
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
      ],
    );
  }
}
