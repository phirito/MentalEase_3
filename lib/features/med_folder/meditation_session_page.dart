import 'package:flutter/material.dart';
import 'package:mentalease_2/features/med_folder/med_manager/session_history_manager.dart';
import 'package:mentalease_2/features/med_folder/meditate_timer.dart';

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
    final sessionHistoryManager = SessionHistoryManager();

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
                await sessionHistoryManager.addSession(selectedDuration);
                onComplete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
