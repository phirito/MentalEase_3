import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomContainer extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final double width;
  final double height;

  // ignore: use_super_parameters
  const CustomContainer({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(96, 167, 167, 167),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 1), // Shadow position
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.quicksand(
              color: Color.fromARGB(255, 46, 46, 46), fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
