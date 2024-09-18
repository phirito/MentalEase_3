import 'dart:async';
import 'package:flutter/material.dart';

class MeditateTimer extends StatefulWidget {
  final int selectedDuration;
  final Function onComplete;

  const MeditateTimer(
      {Key? key, required this.selectedDuration, required this.onComplete})
      : super(key: key);

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
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    setState(() => _isRunning = false);
    _controller.stop();
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _start = 0;
    });
    _controller.reset();
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          children: [
            IconButton(
              onPressed: _startTimer,
              icon: const Icon(Icons.play_arrow),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _pauseTimer,
              icon: const Icon(Icons.pause),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _resetTimer,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _isRunning ? _breathingText : "Press Start to Meditate",
          style: const TextStyle(fontSize: 24, color: Colors.grey),
        ),
      ],
    );
  }
}
