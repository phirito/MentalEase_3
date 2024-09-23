// SessionHistoryPage.dart
import 'package:flutter/material.dart';

class SessionHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> sessionHistory;

  const SessionHistoryPage({super.key, required this.sessionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Session History"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sessionHistory.isEmpty
            ? const Center(child: Text("No sessions completed yet."))
            : ListView.builder(
                itemCount: sessionHistory.length,
                itemBuilder: (context, index) {
                  var session = sessionHistory[index];
                  var durationMinutes = session['duration'] ~/ 60;
                  var durationSeconds = session['duration'] % 60;
                  var time = session['time'] as DateTime;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListTile(
                        title: Text(
                          "$durationMinutes min $durationSeconds sec",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${time.hour}:${time.minute.toString().padLeft(2, '0')} on ${time.day}/${time.month}/${time.year}",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
