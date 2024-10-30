import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfomationPage extends StatelessWidget {
  const InfomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(
              "Information Page",
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(fontSize: 20),
            ),
            const SizedBox(height: 9),
            Text(
              '''
Session Hours
Monday To Friday: 8:00am-4:00pm''',
              textAlign: TextAlign.justify,
              style: GoogleFonts.quicksand(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              '''Where?
              Office of Student Affair and Services DRB Buiding Second Floor
            ''',
              textAlign: TextAlign.justify,
              style: GoogleFonts.quicksand(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              '''
              .''',
              textAlign: TextAlign.justify,
              style: GoogleFonts.quicksand(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
