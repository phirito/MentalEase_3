import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease_2/core/services/api_service.dart';

Future<void> sendMoodToServer(String mood) async {
  try {
    ApiServices apiServices = ApiServices();
    String weekday = DateTime.now().weekday.toString();
    await apiServices.updateMoodForUser(weekday, mood);
  } catch (error) {
    print('Failed to send mood: $error');
  }
}

List<FlSpot> generateMoodChartSpots(Map<String, int> moodStats) {
  List<String> moods = ['Happy', 'Neutral', 'Sad', 'Angry', 'Anxious', 'Tired'];
  List<FlSpot> spots = [];

  for (int i = 0; i < moods.length; i++) {
    spots.add(FlSpot(i.toDouble(), moodStats[moods[i]]!.toDouble()));
  }

  return spots;
}

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
          final bool isSelectedMood = moodOfTheDay == mood['label'];

          return GestureDetector(
            onTap: () async {
              if (!isMoodSelected) {
                handleMoodSelection(mood['label']!, true, mood['label']!);
                await sendMoodToServer(mood['label']!);
              }
            },
            child: Opacity(
              opacity: isMoodSelected ? (isSelectedMood ? 1.0 : 0.5) : 1.0,
              child: Card(
                color: isSelectedMood
                    ? const Color.fromARGB(255, 158, 158, 158)
                    : const Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mood['emoji']!,
                      style: GoogleFonts.quicksand(fontSize: 30),
                    ),
                    Text(mood['label']!, style: GoogleFonts.quicksand()),
                  ],
                ),
              ),
            ),
          );
        },
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
            Column(
              children: [
                Text("Done",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold))
              ],
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

Widget buildShareMoodHistoryButton(Function shareMoodHistory) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 107, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    onPressed: () => shareMoodHistory(),
    child: Text(
      'Share Mood History',
      style: GoogleFonts.quicksand(
        color: const Color.fromARGB(255, 121, 0, 0),
      ),
    ),
  );
}
