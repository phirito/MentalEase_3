import 'package:hive/hive.dart';

class JournalManager {
  late Box _journalBox;

  JournalManager() {
    _journalBox = Hive.box('journalingBox');
  }

  // Load all journal entries from the box
  List<Map<String, dynamic>> loadJournalEntries() {
    List<Map<String, dynamic>> entries = [];
    for (int i = 0; i < _journalBox.length; i++) {
      final item = _journalBox.getAt(i);
      if (item is Map) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(item);
        entries.add({'index': i, ...entry});
      }
    }
    return entries;
  }

  // Add a new journal entry
  Future<void> addJournalEntry(String entry) async {
    await _journalBox.add({'type': 'journal', 'content': entry});
  }

  // Add a new chore to the list
  Future<void> addChore(String chore) async {
    await _journalBox.add({'type': 'chore', 'content': chore, 'done': false});
  }

  // Toggle the completion status of a chore
  Future<void> toggleChoreStatus(int index) async {
    final item = _journalBox.getAt(index);
    if (item is Map) {
      final Map<String, dynamic> chore = Map<String, dynamic>.from(item);
      if (chore['type'] == 'chore') {
        await _journalBox.putAt(index, {
          'type': 'chore',
          'content': chore['content'],
          'done': !(chore['done'] as bool),
        });
      }
    }
  }

  // Delete a journal entry
  Future<void> deleteJournalEntry(int index) async {
    final item = _journalBox.getAt(index);
    if (item is Map) {
      final Map<String, dynamic> entry = Map<String, dynamic>.from(item);
      if (entry['type'] == 'journal') {
        await _journalBox.deleteAt(index);
      }
    }
  }

  // Delete a chore
  Future<void> deleteChore(int index) async {
    final item = _journalBox.getAt(index);
    if (item is Map) {
      final Map<String, dynamic> chore = Map<String, dynamic>.from(item);
      if (chore['type'] == 'chore') {
        await _journalBox.deleteAt(index);
      }
    }
  }

  // Load all chores
  List<Map<String, dynamic>> loadChores() {
    List<Map<String, dynamic>> chores = [];
    for (int i = 0; i < _journalBox.length; i++) {
      final item = _journalBox.getAt(i);
      if (item is Map) {
        final Map<String, dynamic> chore = Map<String, dynamic>.from(item);
        if (chore['type'] == 'chore') {
          chores.add({'index': i, ...chore});
        }
      }
    }
    return chores;
  }

  // Load all journal history entries
  List<Map<String, dynamic>> loadJournalHistory() {
    List<Map<String, dynamic>> history = [];
    for (int i = 0; i < _journalBox.length; i++) {
      final item = _journalBox.getAt(i);
      if (item is Map) {
        final Map<String, dynamic> entry = Map<String, dynamic>.from(item);
        if (entry['type'] == 'journal') {
          history.add({'index': i, ...entry});
        }
      }
    }
    return history;
  }
}
