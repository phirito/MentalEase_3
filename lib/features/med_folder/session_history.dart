import 'package:flutter/material.dart';

class SessionHistory extends StatelessWidget {
  final List<Map<String, dynamic>> sessionHistory;

  const SessionHistory({Key? key, required this.sessionHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sessionHistory.length,
      itemBuilder: (context, index) {
        var session = sessionHistory[index];
        var durationMinutes = session['duration'] ~/ 60;
        var durationSeconds = session['duration'] % 60;
        var time = session['time'] as DateTime;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$durationMinutes min $durationSeconds sec",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${time.hour}:${time.minute.toString().padLeft(2, '0')} on ${time.day}/${time.month}/${time.year}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
