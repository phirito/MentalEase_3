import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_manager/mood_tracker_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:share_plus/share_plus.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MoodTracker extends StatefulWidget {
  final bool showGreeting;
  final Function(String) updateMoodOfTheDay;

  const MoodTracker({
    super.key,
    this.showGreeting = true,
    required this.updateMoodOfTheDay,
  });

  @override
  _MoodTrackerState createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  final MoodTrackerManager _moodTrackerManager = MoodTrackerManager();
  String _selectedMood = '';
  String _moodOfTheDay = '';
  final List<Map<String, String>> _moods = [
    {'emoji': '😀', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😞', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😰', 'label': 'Anxious'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  // List to store mood, date, and time
  final List<Map<String, String>> _moodHistory = [];

  // Mood statistics map
  final Map<String, int> _moodStats = {
    'Happy': 0,
    'Neutral': 0,
    'Sad': 0,
    'Angry': 0,
    'Anxious': 0,
    'Tired': 0,
  };

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadMoodOfTheDay();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    await _moodTrackerManager.loadMoodOfTheDay();
    setState(() {});
  }

  // Initialize local notifications for Android
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _scheduleDailyReminder();
  }

  // Schedule daily reminder notification
  void _scheduleDailyReminder() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'mood_reminder_channel', // ID
      'Daily Mood Reminder', // Name
      channelDescription: 'Reminder to log your daily mood', // Description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule daily notification at 9:00 AM
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Mood Reminder',
      'Don\'t forget to log your mood today!',
      const Time(8, 0, 0),
      platformChannelSpecifics,
    );
  }

  // Save mood of the day with date and time
  void _addMoodToHistory(String mood) {
    String nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String nowTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // Add to history
    _moodHistory.add({'mood': mood, 'date': nowDate, 'time': nowTime});

    // Update mood statistics
    setState(() {
      _moodStats[mood] = (_moodStats[mood] ?? 0) + 1;
    });
  }

  Future<void> _saveMoodOfTheDay(String mood) async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await box.put('moodOfTheDay', mood);
    await box.put('moodDate', today);

    setState(() {
      _moodOfTheDay = mood;
    });
  }

  Future<void> _loadMoodOfTheDay() async {
    var box = await Hive.openBox('moodBox');
    String? savedMood = box.get('moodOfTheDay');
    String? savedDate = box.get('moodDate');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (savedMood != null && savedDate == today) {
      setState(() {
        _moodOfTheDay = savedMood;
      });
    }
  }

  Future<void> _addMoodNoteDialog() async {
    TextEditingController _noteController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add a note"),
          content: TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: "Why are you feeling this way?",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _saveMoodNote(_noteController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveMoodNote(String note) async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await box.put('moodNote_$today', note);
  }

  Widget _buildMoodNoteDisplay() {
    return FutureBuilder(
      future: _getMoodNote(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Text(
            'Note: ${snapshot.data}',
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          );
        } else {
          return const Text("No notes for today's mood.");
        }
      },
    );
  }

  Future<String?> _getMoodNote() async {
    var box = await Hive.openBox('moodBox');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return box.get('moodNote_$today');
  }

  Widget _buildMoodTrendsGraph() {
    final moodStats = _moodTrackerManager.getMoodStats();
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
                spots: _generateMoodChartSpots(moodStats),
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

  // Generate data points for mood statistics chart
  List<FlSpot> _generateMoodChartSpots(Map<String, int> moodStats) {
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

  Widget _buildShareMoodHistoryButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 107, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: _shareMoodHistory,
      child: const Text(
        'Share Mood History',
        style: TextStyle(
          color: Color.fromARGB(255, 121, 0, 0),
        ),
      ),
    );
  }

  void _shareMoodHistory() {
    String moodHistoryText = _moodTrackerManager.getMoodHistoryAsString();
    for (var entry in _moodHistory) {
      moodHistoryText +=
          "${entry['date']} ${entry['time']}: ${entry['mood']}\n";
    }

    Share.share(moodHistoryText);
  }

  // Mood History Carousel with date and time
  Widget _buildMoodHistoryCarousel() {
    final moodHistory = _moodTrackerManager.getMoodHistoryForCarousel();

    if (moodHistory.isEmpty) {
      return const Text('No mood history available');
    }

    return CarouselSlider(
      options: CarouselOptions(height: 150.0, autoPlay: true),
      items: moodHistory.map((entry) {
        return Builder(
          builder: (BuildContext context) {
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
                      entry['date']!,
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

  void _handleMoodSelection(
      String moodLabel, bool selected, String selectedMood) {
    if (_moodOfTheDay.isEmpty) {
      setState(() {
        _selectedMood = selected ? moodLabel : '';
        if (selected) {
          widget.updateMoodOfTheDay(selectedMood);
          _saveMoodOfTheDay(moodLabel);
          widget.updateMoodOfTheDay(moodLabel);
          _addMoodToHistory(moodLabel);
          _moodTrackerManager.updateMoodOfTheDay(selectedMood);
          _addMoodNoteDialog();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.size.width * 0.05,
            vertical: mediaQuery.size.height * 0.03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showGreeting)
                Center(
                    child:
                        _buildGreetingWidget(mediaQuery)), // Greeting centered
              SizedBox(
                  height: mediaQuery.size.height * 0.03), // Adjusted spacing

              // Mood Selection Grid
              _buildSectionHeader("Select Your Mood", mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.01),
              _buildMoodSelectionGrid(mediaQuery, isLandscape),
              SizedBox(height: mediaQuery.size.height * 0.03),

              // Mood of the day display
              Center(child: _buildMoodDisplay(mediaQuery)),
              SizedBox(height: mediaQuery.size.height * 0.02),

              // Mood note display (if available)
              if (_moodOfTheDay.isNotEmpty) ...[
                Center(child: _buildMoodNoteDisplay()),
                SizedBox(height: mediaQuery.size.height * 0.03),
              ],

              // Mood trends graph (centered and spaced)
              Center(child: _buildMoodTrendsGraph()),
              SizedBox(height: mediaQuery.size.height * 0.04),

              // Mood history carousel (centered and spaced)
              _buildSectionHeader("Mood History", mediaQuery),
              SizedBox(height: mediaQuery.size.height * 0.01),
              Center(child: _buildMoodHistoryCarousel()),
              SizedBox(height: mediaQuery.size.height * 0.04),

              // Share button (centered)
              Center(child: _buildShareMoodHistoryButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelectionGrid(MediaQueryData mediaQuery, bool isLandscape) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 4 : 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.2,
      ),
      itemCount: _moods.length,
      itemBuilder: (context, index) {
        final mood = _moods[index];
        return GestureDetector(
          onTap: () {
            _handleMoodSelection(mood['label']!, true, mood['label']!);
          },
          child: Card(
            color: _moodOfTheDay == mood['label']
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
    );
  }

  Widget _buildMoodDisplay(MediaQueryData mediaQuery) {
    return Center(
      child: Text(
        _moodOfTheDay.isNotEmpty
            ? "Today's Mood: $_moodOfTheDay"
            : "No mood selected for today.",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildGreetingWidget(MediaQueryData mediaQuery) {
    return Text(
      'Welcome to your Mood Tracker!',
      style: TextStyle(fontSize: mediaQuery.size.width * 0.06),
    );
  }
}

_buildSectionHeader(String title, MediaQueryData mediaQuery) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: mediaQuery.size.height * 0.01),
    child: Text(
      title,
      style: TextStyle(
        fontSize: mediaQuery.size.width * 0.06,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    ),
  );
}

void main() async {
  await Hive.initFlutter();
  runApp(MaterialApp(
    home: MoodTracker(
      updateMoodOfTheDay: (mood) {},
    ),
  ));
}
