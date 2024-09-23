import 'package:hive_flutter/hive_flutter.dart';

class SessionHistoryManager {
  static const String _boxName = 'sessionBox'; // The Hive box name
  static const String _keyName = 'sessionHistory'; // Key for session history

  // Open the Hive box for session history
  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  // Add a session to history
  Future<void> addSession(int duration) async {
    final box = await _openBox();
    final sessionHistory = await getSessionHistory();

    final session = {
      'duration': duration,
      'time': DateTime.now().toIso8601String(),
    };

    sessionHistory.add(session);

    await box.put(_keyName, sessionHistory);
  }

  Future<List<Map<String, dynamic>>> getSessionHistory() async {
    final box = await _openBox();
    final history = box.get(_keyName, defaultValue: []);
    return List<Map<String, dynamic>>.from(history);
  }

  Future<void> clearSessionHistory() async {
    final box = await _openBox();
    await box.delete(_keyName);
  }
}
