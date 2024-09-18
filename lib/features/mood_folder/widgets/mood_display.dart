import 'package:flutter/material.dart';

class MoodDisplay extends StatelessWidget {
  const MoodDisplay({
    super.key,
    required this.moodOfTheDay,
    required this.mediaQuery,
  });

  final String moodOfTheDay;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        moodOfTheDay.isNotEmpty
            ? 'Today\'s mood: $moodOfTheDay'
            : 'Please select a mood',
        style: TextStyle(fontSize: mediaQuery.textScaleFactor * 18),
      ),
    );
  }
}
