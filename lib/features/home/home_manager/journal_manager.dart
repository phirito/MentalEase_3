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
      final item = _journalBox.getAt(i) as Map<String, dynamic>;
      entries.add({'index': i, ...item});
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
    final item = _journalBox.getAt(index) as Map<String, dynamic>;
    if (item['type'] == 'chore') {
      await _journalBox.putAt(index,
          {'type': 'chore', 'content': item['content'], 'done': !item['done']});
    }
  }

  // Delete a journal entry
  Future<void> deleteJournalEntry(int index) async {
    final item = _journalBox.getAt(index) as Map<String, dynamic>;
    if (item['type'] == 'journal') {
      await _journalBox.deleteAt(index);
    }
  }

  // Delete a chore
  Future<void> deleteChore(int index) async {
    final item = _journalBox.getAt(index) as Map<String, dynamic>;
    if (item['type'] == 'chore') {
      await _journalBox.deleteAt(index);
    }
  }

  // Load all chores
  List<Map<String, dynamic>> loadChores() {
    List<Map<String, dynamic>> chores = [];
    for (int i = 0; i < _journalBox.length; i++) {
      final item = _journalBox.getAt(i) as Map<String, dynamic>;
      if (item['type'] == 'chore') {
        chores.add({'index': i, ...item});
      }
    }
    return chores;
  }

  // Load all journal history entries
  List<Map<String, dynamic>> loadJournalHistory() {
    List<Map<String, dynamic>> history = [];
    for (int i = 0; i < _journalBox.length; i++) {
      final item = _journalBox.getAt(i) as Map<String, dynamic>;
      if (item['type'] == 'journal') {
        history.add({'index': i, ...item});
      }
    }
    return history;
  }
}
