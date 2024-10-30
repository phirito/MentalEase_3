import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showMoodNoteDialog(BuildContext context) {
  TextEditingController noteController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add a note", style: GoogleFonts.quicksand()),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: "Why are you feeling this way?",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel", style: GoogleFonts.quicksand()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(noteController.text);
            },
            child: Text("Save", style: GoogleFonts.quicksand()),
          ),
        ],
      );
    },
  );
}
