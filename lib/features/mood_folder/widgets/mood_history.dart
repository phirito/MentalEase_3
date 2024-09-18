import 'package:flutter/material.dart';

class MoodHistoryChart extends StatelessWidget {
  const MoodHistoryChart({
    super.key,
    required this.mediaQuery,
    required this.moods,
    required this.moodHistory,
  });

  final MediaQueryData mediaQuery;
  final List<Map<String, String>> moods;
  final List<String> moodHistory;

  @override
  Widget build(BuildContext context) {
    final Map<String, int> moodCounts = {};
    for (var mood in moodHistory) {
      moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
    }

    return SizedBox(
      height: mediaQuery.size.height * 0.3,
      width: mediaQuery.size.width * 0.9,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: moods.map((mood) {
            final count = moodCounts[mood['label']] ?? 0;
            double barHeight =
                mediaQuery.size.height * 0.1 * (count / moodHistory.length);
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.size.width * 0.02),
              child: Column(
                children: [
                  Text(
                    mood['emoji']!,
                    style: TextStyle(fontSize: mediaQuery.textScaleFactor * 25),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.01),
                  Text(
                    '$count',
                    style: TextStyle(fontSize: mediaQuery.textScaleFactor * 10),
                  ),
                  SizedBox(height: mediaQuery.size.height * 0.01),
                  Container(
                    width: mediaQuery.size.width * 0.1,
                    height: barHeight > 0
                        ? barHeight
                        : mediaQuery.size.height * 0.0,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 116, 8, 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
