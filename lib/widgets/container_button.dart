import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  const ContainerButton({
    super.key,
    required this.mediaQuery,
    required this.onTap,
  });

  final MediaQueryData mediaQuery;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 0.05,
          vertical: mediaQuery.size.height * 0.02,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 126, 0, 0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        alignment: Alignment.center,
        child: Text(
          "Show Mood History",
          style: TextStyle(
            fontSize: mediaQuery.textScaleFactor * 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
