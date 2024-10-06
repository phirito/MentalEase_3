import 'package:flutter/material.dart';
import 'package:mentalease_2/features/home/home_widgets/features_widgets.dart';

Widget buildHomeContent({
  required String moodOfTheDay,
  required bool hasMeditatedToday,
  required List<String> toDoList,
  required Future<void> Function() onRefresh,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Center(
        child: RefreshIndicator(
          onRefresh: onRefresh, // This function is called on pull-to-refresh
          color: const Color.fromARGB(
              255, 116, 0, 0), // Customize the color of the loading indic-ator
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Allows pull-to-refresh
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 121, 0, 0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        child: const Text(
                          'Quote of the day',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      const Divider(),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          'All our dreams can come true, if we have the courage to pursue them. \n\n-Walt Disney',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomContainer(
                              text:
                                  'Mood Today: \n ${moodOfTheDay.isNotEmpty ? moodOfTheDay : 'No mood selected'}',
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              width: 150,
                              height: 150,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomContainer(
                              text:
                                  'Meditation Status: ${hasMeditatedToday ? 'Completed' : 'Not Completed'}',
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: CustomContainer(
                          text:
                              'To-do list:\n${toDoList.isNotEmpty ? toDoList.join('\n') : 'No tasks'}',
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          width: 400,
                          height: 150,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
