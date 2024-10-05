import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:mentalease_2/features/home/home_manager/meditation_manager.dart';
import 'package:mentalease_2/features/home/home_manager/mood_tracker_manager.dart';
import 'package:mentalease_2/features/home/home_manager/todo_manager.dart';
import 'package:mentalease_2/features/home/home_widgets/home_content_widgets.dart';
import 'package:mentalease_2/features/jour_folder/journaling_area.dart';
import 'package:mentalease_2/features/med_folder/meditate_area.dart';
import 'package:mentalease_2/features/mood_folder/mood_tracker.dart';

class HomeArea extends StatefulWidget {
  const HomeArea({super.key});

  @override
  State<HomeArea> createState() => _HomeAreaState();
}

class _HomeAreaState extends State<HomeArea> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Use shared instances of managers to ensure that state is consistent across pages
  final MoodTrackerManager _moodTrackerManager = MoodTrackerManager();
  final MeditationManager _meditationManager = MeditationManager();
  final ToDoManager _toDoManager = ToDoManager();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _moodTrackerManager.loadMoodOfTheDay();
    await _meditationManager.checkMeditationStatus();
    await _toDoManager.loadToDoList(); // Ensure session history is loaded

    // Ensure state update happens after data is fully loaded
    if (mounted) {
      setState(() {});
    }
  }

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String today = DateTime.now().toIso8601String().split('T').first;
    String? moodToday = _moodTrackerManager.getMood(today);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('Mental',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Image.asset(
              'assets/images/mentalease_logo.png',
              width: 40,
              height: 40,
            ),
            const Text('Ease',
                style: TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 116, 8, 0),
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
                  Image.asset(
                    'assets/images/mentalease_logo.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MentalEase Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: const Text('Mood Tracker'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.spa),
              title: const Text('Meditation'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Journaling'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone_enabled),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: PageView(
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
          ),
          MoodTracker(updateMoodOfTheDay: _updateMoodOfTheDay),
          MeditateArea(updateMeditationStatus: _updateMeditationStatus),
          JournalingArea(
            addToDoCallback: _addToDoItem,
            removeToDoCallback: _removeToDoItem,
          ),
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            activeColor: const Color.fromARGB(255, 128, 0, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.track_changes),
            title: const Text('Mood'),
            activeColor: const Color.fromARGB(255, 116, 8, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.spa),
            title: const Text('Meditate'),
            activeColor: const Color.fromARGB(255, 116, 8, 0),
            inactiveColor: Colors.grey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.book),
            title: const Text('Journaling'),
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
