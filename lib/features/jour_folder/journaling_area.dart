import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_manager/journal_manager.dart';

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

  void _addJournalEntry() async {
    if (_journalController.text.isNotEmpty) {
      await _journalManager.addJournalEntry(_journalController.text);
      _journalController.clear();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry Successful! Swipe to left <--'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _addChore() async {
    if (_noteController.text.isNotEmpty) {
      await _journalManager.addChore(_noteController.text);
      widget.addToDoCallback(_noteController.text);
      _noteController.clear();
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
    await _journalManager.toggleChoreStatus(index);
    setState(() {});

    if (_journalManager.loadChores()[index]['done']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task marked as done! Removing in 3 seconds...'),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () async {
        await _journalManager.deleteChore(index);
        widget
            .removeToDoCallback(_journalManager.loadChores()[index]['content']);
        setState(() {});
      });
    }
  }

  void _deleteChore(int index) async {
    String chore = _journalManager.loadChores()[index]['content'];
    await _journalManager.deleteChore(index);
    widget.removeToDoCallback(chore);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteJournalEntry(int index) async {
    await _journalManager.deleteJournalEntry(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journal entry deleted!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PageController(),
        children: [
          _buildJournalEntryPage(),
          _buildJournalHistoryPage(),
        ],
      ),
    );
  }

  Widget _buildJournalEntryPage() {
    List<Map<String, dynamic>> chores = _journalManager.loadChores();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Journal Entry Section
          const Text(
            "Journal Entry",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _journalController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "Write about your day...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addJournalEntry,
            child: const Text(
              "Add Entry",
              style: TextStyle(color: Color.fromARGB(255, 116, 8, 0)),
            ),
          ),
          const SizedBox(height: 20),

          // Notes/To-Do Section
          const Text(
            "Notes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: "Add a note...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addChore,
            child: const Text(
              "Add Note",
              style: TextStyle(color: Color.fromARGB(255, 116, 8, 0)),
            ),
          ),
          const SizedBox(height: 20),

          // To-Do List
          const Text(
            "To-Do List",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: TextStyle(
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

  Widget _buildJournalHistoryPage() {
    List<Map<String, dynamic>> history = _journalManager.loadJournalHistory();
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
                    _deleteJournalEntry(history[index]['index']);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
