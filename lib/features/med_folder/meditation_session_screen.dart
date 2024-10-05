import 'package:flutter/material.dart';
import 'package:mentalease_2/features/med_folder/meditate_timer.dart';
import 'package:mentalease_2/features/home/home_manager/meditation_manager.dart';

class MeditationSessionPage extends StatelessWidget {
  final int selectedDuration;
  final Function onComplete;

  const MeditationSessionPage({
    super.key,
    required this.selectedDuration,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final MeditationManager _meditationManager = MeditationManager();

    return Scaffold(
      appBar: AppBar(title: const Text("Meditation Session")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MeditateTimer(
              selectedDuration: selectedDuration,
              onComplete: () async {
                final session = {
                  'duration': selectedDuration,
                  'time': DateTime.now().toIso8601String(),
                };
                await _meditationManager.saveSessionHistory(session);
                onComplete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
