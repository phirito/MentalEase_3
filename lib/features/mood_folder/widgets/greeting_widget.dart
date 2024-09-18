import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Text(
      "How was your day?",
      style: TextStyle(fontSize: mediaQuery.textScaleFactor * 24),
    );
  }
}
