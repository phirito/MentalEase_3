import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease_2/features/med_folder/meditate_timer.dart';

class MeditationSessionPage extends StatelessWidget {
  final int selectedDuration;
  final Function onComplete;

  const MeditationSessionPage({
    Key? key,
    required this.selectedDuration,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meditation Session", style: GoogleFonts.quicksand()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MeditateTimer(
              selectedDuration: selectedDuration,
              onComplete: () {
                onComplete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
