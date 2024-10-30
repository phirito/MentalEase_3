import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SessionHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> sessionHistory;

  const SessionHistoryPage({super.key, required this.sessionHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Session History",
          style: GoogleFonts.quicksand(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sessionHistory.isEmpty
            ? Center(
                child: Text(
                "No sessions completed yet.",
                style: GoogleFonts.quicksand(),
              ))
            : ListView.builder(
                itemCount: sessionHistory.length,
                itemBuilder: (context, index) {
                  var session = sessionHistory[index];
                  var durationMinutes = session['duration'] ~/ 60;
                  var durationSeconds = session['duration'] % 60;

                  // Ensure the time is correctly parsed as a DateTime object
                  DateTime time;
                  if (session['time'] is String) {
                    time = DateTime.parse(session['time']);
                  } else if (session['time'] is DateTime) {
                    time = session['time'];
                  } else {
                    // Fallback if the data is corrupted or unexpected
                    time = DateTime.now();
                  }

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
                          style: GoogleFonts.quicksand(
                              fontSize: 16, color: Colors.grey),
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
