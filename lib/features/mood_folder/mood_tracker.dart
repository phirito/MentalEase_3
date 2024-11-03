import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mentalease_2/features/home/home_manager/mood_tracker_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'notification_service.dart';
import 'mood_widget.dart';
import 'mood_note_dialog.dart';

class MoodTracker extends StatefulWidget {
  final MoodTrackerManager moodTrackerManager;
  final Function(String) updateMoodOfTheDay;
  final String idNumber; // Add idNumber to pass it to the grid

  const MoodTracker({
    super.key,
    required this.moodTrackerManager,
    required this.updateMoodOfTheDay,
    required this.idNumber, // Make it a required parameter
  });

  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Map<String, String>> _moods = [
    {'emoji': '😀', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😞', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  List<FlSpot> generateMoodChartSpots(Map<String, int> moodStats) {
    List<String> moods = [
      'Happy',
      'Neutral',
      'Sad',
      'Angry',
      'Anxious',
      'Tired'
    ];
    List<FlSpot> spots = [];

    for (int i = 0; i < moods.length; i++) {
      spots.add(FlSpot(i.toDouble(), moodStats[moods[i]]!.toDouble()));
    }

    return spots;
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications(flutterLocalNotificationsPlugin);
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    await widget.moodTrackerManager
        .loadMoodOfTheDay(widget.idNumber); // Pass `idNumber`
    setState(() {});
  }

  void _handleMoodSelection(
      String moodLabel, bool selected, String selectedMood) {
    if (widget.moodTrackerManager.moodOfTheDay.isEmpty) {
      setState(() {
        if (selected) {
          widget.updateMoodOfTheDay(selectedMood); // Remove `context`
          widget.moodTrackerManager.updateMoodOfTheDay(
              selectedMood, widget.idNumber, context); // Keep `context` here
          _addMoodNoteDialog();
        }
      });
    }
  }

  void _shareMoodHistory() {
    String moodHistoryText = widget.moodTrackerManager.getMoodHistoryAsString();
    Share.share(moodHistoryText);
  }

  Future<void> saveMoodNoteData(String note) async {
    var box = Hive.box('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await box.put('moodNote_$today', note);
  }

  Future<String?> getMoodNote() async {
    var box = Hive.box('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return box.get('moodNote_$today');
  }

  Future<void> _addMoodNoteDialog() async {
    String? note = await showMoodNoteDialog(context);
    if (note != null) {
      await saveMoodNoteData(note);
    }
  }

  Widget _buildMoodNoteDisplay() {
    return FutureBuilder(
      future: getMoodNote(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data != null) {
          return Text(
            'Note: ${snapshot.data}',
            style: GoogleFonts.quicksand(
                fontSize: 18, fontStyle: FontStyle.italic),
          );
        } else {
          return Text("No notes for today's mood.",
              style: GoogleFonts.quicksand());
        }
      },
    );
  }

  Widget _buildMoodDisplay(MediaQueryData mediaQuery) {
    return Center(
      child: Text(
        widget.moodTrackerManager.moodOfTheDay.isNotEmpty
            ? "Today's Mood: ${widget.moodTrackerManager.moodOfTheDay}"
            : "No mood selected for today.",
        style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionHeader(String title, MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.01),
      child: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: mediaQuery.size.width * 0.06,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget buildMoodTrendsGraph() {
    Map<String, int> moodStats = widget.moodTrackerManager.getMoodStats();

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

  Widget buildMoodHistoryCarousel() {
    List<Map<String, dynamic>> moodHistory =
        widget.moodTrackerManager.getAllMoodHistory();

    if (moodHistory.isEmpty) {
      return const Text('No mood history available');
    }

    return CarouselSlider(
      options: CarouselOptions(height: 150.0, autoPlay: true),
      items: moodHistory.map((entry) {
        return Builder(
          builder: (BuildContext context) {
            DateTime parsedDate = DateTime.parse(entry['date']);
            String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 116, 0, 0)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      entry['mood']!,
                      style:
                          const TextStyle(fontSize: 24.0, color: Colors.white),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.05,
            vertical: mediaQuery.size.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mediaQuery.size.height * 0.03),
              _buildSectionHeader("Select Your Mood", mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.01),
              buildMoodSelectionGrid(
                context,
                _moods,
                widget.moodTrackerManager.moodOfTheDay,
                widget.idNumber, // Pass the idNumber parameter
                _handleMoodSelection,
                widget.moodTrackerManager.moodOfTheDay.isNotEmpty,
              ),
              SizedBox(height: mediaQuery.size.height * 0.03),

              // Mood of the day display
              Center(child: _buildMoodDisplay(mediaQuery)),
              SizedBox(height: mediaQuery.size.height * 0.02),
              Center(child: _buildMoodNoteDisplay()),
              SizedBox(height: mediaQuery.size.height * 0.03),
              Center(child: buildMoodTrendsGraph()),
              SizedBox(height: mediaQuery.size.height * 0.04),
              _buildSectionHeader("Mood History", mediaQuery),
              Center(child: buildMoodHistoryCarousel()),
              SizedBox(height: mediaQuery.size.height * 0.04),
              Center(child: buildShareMoodHistoryButton(_shareMoodHistory)),
            ],
          ),
        ),
      ),
    );
  }
}
