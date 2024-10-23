import 'package:flutter/material.dart';

class InfomationPage extends StatelessWidget {
  const InfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Text(
              "Information Page",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 9),
            Text(
              '''
Session Hours
Monday To Friday: 8:00am-4:00pm''',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
            SizedBox(height: 16),
            Text(
              '''Where?
  OSAS Department 
  Second Floor
''',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
            SizedBox(height: 16),
            Text(
              '''
              .''',
              textAlign: TextAlign.justify, // Justify text alignment
            ),
          ],
        ),
      ),
    );
  }
}
