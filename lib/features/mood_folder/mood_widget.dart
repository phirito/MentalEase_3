import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget buildMoodSelectionGrid(
  BuildContext context,
  List<Map<String, String>> moods,
  String moodOfTheDay,
  Function(String, bool, String) handleMoodSelection,
  bool isMoodSelected,
) {
  final mediaQuery = MediaQuery.of(context);
  final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

  return Stack(
    children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isLandscape ? 4 : 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.2,
        ),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          return GestureDetector(
            onTap: () {
              if (!isMoodSelected) {
                handleMoodSelection(mood['label']!, true, mood['label']!);
              }
            },
            child: Card(
              color: moodOfTheDay == mood['label']
                  ? const Color.fromARGB(255, 158, 158, 158)
                  : const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mood['emoji']!,
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(mood['label']!),
                ],
              ),
            ),
          );
        },
      ),
      if (isMoodSelected)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      if (isMoodSelected)
        Column(
          children: [
            Center(
              child: Icon(
                Icons.check_circle_outline,
                size: 100,
                color: const Color.fromARGB(255, 24, 24, 24).withOpacity(0.8),
              ),
            ),
            const Column(
              children: [Text("Done")],
            )
          ],
        ),
    ],
  );
}

Widget buildMoodTrendsGraph(Map<String, int> moodStats) {
  return SizedBox(
    height: 200,
    child: Padding(
      padding: const EdgeInsets.all(9.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: generateMoodChartSpots(moodStats),
              isCurved: true,
              barWidth: 3,
              color: const Color.fromARGB(255, 114, 0, 0),
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
      ),
    ),
  );
}

List<FlSpot> generateMoodChartSpots(Map<String, int> moodStats) {
  List<String> moods = ['Happy', 'Neutral', 'Sad', 'Angry', 'Anxious', 'Tired'];
  List<FlSpot> spots = [];

  for (int i = 0; i < moods.length; i++) {
    spots.add(FlSpot(i.toDouble(), moodStats[moods[i]]!.toDouble()));
  }

  return spots;
}

Widget buildShareMoodHistoryButton(Function shareMoodHistory) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 107, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    onPressed: () => shareMoodHistory(),
    child: const Text(
      'Share Mood History',
      style: TextStyle(
        color: Color.fromARGB(255, 121, 0, 0),
      ),
    ),
  );
}
