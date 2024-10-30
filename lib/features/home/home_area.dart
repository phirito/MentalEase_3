import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease_2/core/services/api_service.dart';
import 'package:mentalease_2/features/home/home_manager/meditation_manager.dart';
import 'package:mentalease_2/features/home/home_manager/mood_tracker_manager.dart';
import 'package:mentalease_2/features/home/home_manager/todo_manager.dart';
import 'package:mentalease_2/features/home/home_widgets/home_content_widgets.dart';
import 'package:mentalease_2/features/home/home_widgets/infomation_page.dart';
import 'package:mentalease_2/features/jour_folder/journaling_area.dart';
import 'package:mentalease_2/features/med_folder/meditate_area.dart';
import 'package:mentalease_2/features/mood_folder/mood_tracker.dart';
import 'package:mentalease_2/features/signin/login_area.dart';
import 'package:hive/hive.dart';

class HomeArea extends StatefulWidget {
  const HomeArea({super.key});

  @override
  State<HomeArea> createState() => _HomeAreaState();
}

class _HomeAreaState extends State<HomeArea> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final MoodTrackerManager _moodTrackerManager = MoodTrackerManager();
  final MeditationManager _meditationManager = MeditationManager();
  final ToDoManager _toDoManager = ToDoManager();

  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _updateMoodOfTheDay(String selectedMood) async {
    await _moodTrackerManager.updateMoodOfTheDay(selectedMood);
    setState(() {});
  }

  void _addToDoItem(String newToDo) async {
    await _toDoManager.addToDoItem(newToDo);
    setState(() {});
  }

  void _removeToDoItem(String toDo) async {
    await _toDoManager.removeToDoItem(toDo);
    setState(() {});
  }

  void _updateMeditationStatus(bool status) async {
    await _meditationManager.updateMeditationStatus();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _moodTrackerManager.loadMoodOfTheDay();
    await _meditationManager.checkMeditationStatus();
    await _toDoManager.loadToDoList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String today = DateTime.now().toIso8601String().split('T').first;
    // ignore: unused_local_variable
    String? moodToday = _moodTrackerManager.getMood(today);

    // ignore: unused_element, no_leading_underscores_for_local_identifiers
    List<String> _loadToDoList() {
      Box journalBox = Hive.box('journalingBox');
      return journalBox.values.cast<String>().toList();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Mental',
                style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Image.asset(
              'assets/images/mentalease_logo.png',
              width: 40,
              height: 40,
            ),
            Text('Ease',
                style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 116, 8, 0),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 116, 8, 0),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    'User Name',
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Home', style: GoogleFonts.quicksand()),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: Text('Mood Tracker', style: GoogleFonts.quicksand()),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.spa),
              title: Text('Meditation', style: GoogleFonts.quicksand()),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: Text('Journaling', style: GoogleFonts.quicksand()),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone_enabled),
              title: Text('Information Page', style: GoogleFonts.quicksand()),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const InfomationPage();
                }));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('Logout', style: GoogleFonts.quicksand()),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginForm(
                      apiService: ApiServices(), formKey: _formKey);
                }));
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: <Widget>[
            buildHomeContent(
              moodOfTheDay: _moodTrackerManager.moodOfTheDay,
              toDoList: _toDoManager.toDoList,
              hasMeditatedToday: _meditationManager.hasMeditatedToday,
              onRefresh: _loadData,
              apiService: _apiService,
            ),
            MoodTracker(
              updateMoodOfTheDay: _updateMoodOfTheDay,
              moodTrackerManager: _moodTrackerManager,
            ),
            MeditateArea(updateMeditationStatus: _updateMeditationStatus),
            JournalingArea(
              addToDoCallback: (String newToDo) {
                _addToDoItem(newToDo);
              },
              removeToDoCallback: (String toDo) {
                _removeToDoItem(toDo);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: Text('Home', style: GoogleFonts.quicksand()),
            activeColor: const Color.fromARGB(255, 128, 0, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.track_changes),
            title: Text('Mood', style: GoogleFonts.quicksand()),
            activeColor: const Color.fromARGB(255, 116, 8, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.spa),
            title: Text('Meditate', style: GoogleFonts.quicksand()),
            activeColor: const Color.fromARGB(255, 116, 8, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.book),
            title: Text('Journaling', style: GoogleFonts.quicksand()),
            activeColor: const Color.fromARGB(255, 116, 8, 0),
            inactiveColor: Colors.grey,
          ),
        ],
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        iconSize: 24,
        height: 60,
      ),
    );
  }
}
