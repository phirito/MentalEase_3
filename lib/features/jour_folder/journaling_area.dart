// File: journaling_area.dart
import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_manager/journal_manager.dart';
import 'package:mentalease_2/features/jour_folder/journal_entry_page.dart';
import 'package:mentalease_2/features/jour_folder/journal_history_page.dart';

class JournalingArea extends StatefulWidget {
  final Function(String) addToDoCallback;
  final Function(String) removeToDoCallback;

  const JournalingArea({
    super.key,
    required this.addToDoCallback,
    required this.removeToDoCallback,
  });

  @override
  _JournalingAreaState createState() => _JournalingAreaState();
}

class _JournalingAreaState extends State<JournalingArea> {
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  late JournalManager _journalManager;

  @override
  void initState() {
    super.initState();
    _journalManager = JournalManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PageController(),
        children: [
          JournalEntryPage(
            journalManager: _journalManager,
            addToDoCallback: widget.addToDoCallback,
            journalController: _journalController,
            noteController: _noteController,
            removeToDoCallback: widget.removeToDoCallback,
          ),
          JournalHistoryPage(journalManager: _journalManager),
        ],
      ),
    );
  }
}
