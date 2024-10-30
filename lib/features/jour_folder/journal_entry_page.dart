import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease_2/features/home/home_manager/journal_manager.dart';

class JournalEntryPage extends StatefulWidget {
  final JournalManager journalManager;
  final Function(String) addToDoCallback;
  final TextEditingController journalController;
  final TextEditingController noteController;
  final Function(String) removeToDoCallback;

  const JournalEntryPage({
    Key? key,
    required this.journalManager,
    required this.addToDoCallback,
    required this.journalController,
    required this.noteController,
    required this.removeToDoCallback,
  }) : super(key: key);

  @override
  _JournalEntryPageState createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  void _addJournalEntry() async {
    if (widget.journalController.text.isNotEmpty) {
      await widget.journalManager
          .addJournalEntry(widget.journalController.text);
      widget.journalController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Entry Successful! Swipe to left <--',
            style: GoogleFonts.quicksand(),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addChore() async {
    if (widget.noteController.text.isNotEmpty) {
      await widget.journalManager.addChore(widget.noteController.text);
      widget.addToDoCallback(widget.noteController.text);
      widget.noteController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleChoreDone(int index) async {
    await widget.journalManager.toggleChoreStatus(index);
    setState(() {});

    List<Map<String, dynamic>> chores =
        widget.journalManager.loadChores().map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    if (chores[index]['done']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Task marked as done! Removing in 3 seconds...',
            style: GoogleFonts.quicksand(),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () async {
        await widget.journalManager.deleteChore(index);
        widget.removeToDoCallback(chores[index]['content']);
        setState(() {});
      });
    }
  }

  void _deleteChore(int index) async {
    List<Map<String, dynamic>> chores =
        widget.journalManager.loadChores().map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
    String chore = chores[index]['content'];
    await widget.journalManager.deleteChore(index);
    widget.removeToDoCallback(chore);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task deleted!',
          style: GoogleFonts.quicksand(),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> chores =
        widget.journalManager.loadChores().map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Journal Entry",
            style: GoogleFonts.quicksand(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: widget.journalController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Write about your day...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addJournalEntry,
            child: Text(
              "Add Entry",
              style: GoogleFonts.quicksand(
                  color: const Color.fromARGB(255, 116, 8, 0)),
            ),
          ),
          const SizedBox(height: 20),

          // Notes/To-Do Section
          Text(
            "Notes",
            style: GoogleFonts.quicksand(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: widget.noteController,
            decoration: const InputDecoration(
              hintText: "Add a note...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addChore,
            child: Text(
              "Add Note",
              style: GoogleFonts.quicksand(
                  color: const Color.fromARGB(255, 116, 8, 0)),
            ),
          ),
          const SizedBox(height: 20),

          // To-Do List
          Text(
            "To-Do List",
            style: GoogleFonts.quicksand(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: chores.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: chores[index]['done'],
                  onChanged: (bool? value) {
                    _toggleChoreDone(index);
                  },
                ),
                title: Text(
                  chores[index]['content'],
                  style: GoogleFonts.quicksand(
                    decoration: chores[index]['done']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteChore(index);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
