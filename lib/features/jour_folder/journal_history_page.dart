import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_manager/journal_manager.dart';

class JournalHistoryPage extends StatefulWidget {
  final JournalManager journalManager;

  const JournalHistoryPage({Key? key, required this.journalManager})
      : super(key: key);

  @override
  _JournalHistoryPageState createState() => _JournalHistoryPageState();
}

class _JournalHistoryPageState extends State<JournalHistoryPage> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> history =
        widget.journalManager.loadJournalHistory().map((item) {
      return Map<String, dynamic>.from(item);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal History"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: history.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(history[index]['content']),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteJournalEntry(context, index);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteJournalEntry(BuildContext context, int index) async {
    await widget.journalManager.deleteJournalEntry(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry deleted!'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {}); // Refresh the list after deletion
  }
}
