import 'package:flutter/material.dart';

Future<String?> showMoodNoteDialog(BuildContext context) {
  TextEditingController noteController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add a note"),
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
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(noteController.text);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
