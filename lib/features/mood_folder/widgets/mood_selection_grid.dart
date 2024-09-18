import 'package:flutter/material.dart';

class MoodSelectionGrid extends StatelessWidget {
  const MoodSelectionGrid({
    super.key,
    required this.mediaQuery,
    required this.isLandscape,
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
    required this.moodOfTheDay,
  });

  final MediaQueryData mediaQuery;
  final bool isLandscape;
  final List<Map<String, String>> moods;
  final String selectedMood;
  final String moodOfTheDay;
  final Function(String, bool) onMoodSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mediaQuery.size.height * 0.3,
      child: GridView.count(
        crossAxisCount: isLandscape ? 4 : 3,
        mainAxisSpacing: mediaQuery.size.width * 0.02,
        crossAxisSpacing: mediaQuery.size.width * 0.02,
        childAspectRatio: 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: moods.map((mood) {
          return ChoiceChip(
            label: Text(
              mood['emoji']!,
              style: TextStyle(fontSize: mediaQuery.textScaleFactor * 30),
            ),
            selected: selectedMood == mood['label'],
            onSelected: moodOfTheDay.isEmpty
                ? (selected) => onMoodSelected(mood['label']!, selected)
                : null, // Disable selection if mood is already chosen for the day
          );
        }).toList(),
      ),
    );
  }
}
