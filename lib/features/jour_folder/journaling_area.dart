import 'package:flutter/material.dart';

class JournalingArea extends StatefulWidget {
  final Function(String) addToDoCallback;
  final Function(String)
      removeToDoCallback; // Callback to remove chores from HomeArea

  const JournalingArea(
      {super.key,
      required this.addToDoCallback,
      required this.removeToDoCallback});

  @override
  _JournalingAreaState createState() => _JournalingAreaState();
}

class _JournalingAreaState extends State<JournalingArea> {
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<String> _journalEntries = [];
  final List<String> _chores = [];
  final List<bool> _choresDone = [];
  final PageController _pageController = PageController();

  // Add Journal Entry
  void _addJournalEntry() {
    if (_journalController.text.isNotEmpty) {
      setState(() {
        _journalEntries.insert(0, _journalController.text);
        _journalController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry Successful!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Add Chore/Note
  void _addChore(String chore) {
    setState(() {
      _chores.add(chore);
      _choresDone.add(false);
      widget.addToDoCallback(chore); // Call the callback to update HomeArea
    });
    _noteController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Toggle To-Do item as done/undone
  void _toggleChoreDone(int index) {
    setState(() {
      _choresDone[index] = !_choresDone[index];
    });

    if (_choresDone[index]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task marked as done! Removing in 3 seconds...'),
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          widget.removeToDoCallback(_chores[index]); // Remove from HomeArea
          _chores.removeAt(index);
          _choresDone.removeAt(index);
        });
      });
    }
  }

  // Delete a Chore
  void _deleteChore(int index) {
    setState(() {
      widget.removeToDoCallback(
          _chores[index]); // Call the callback to remove from HomeArea
      _chores.removeAt(index);
      _choresDone.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildJournalEntryPage(),
          _buildJournalHistoryPage(),
        ],
      ),
    );
  }

  Widget _buildJournalEntryPage() {
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
            onPressed: () {
              if (_noteController.text.isNotEmpty) {
                _addChore(_noteController.text);
              }
            },
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
            itemCount: _chores.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: _choresDone[index],
                  onChanged: (bool? value) {
                    _toggleChoreDone(index);
                  },
                ),
                title: Text(
                  _chores[index],
                  style: TextStyle(
                    decoration: _choresDone[index]
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

  // Journal History Page
  Widget _buildJournalHistoryPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal History"),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _journalEntries.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_journalEntries[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
