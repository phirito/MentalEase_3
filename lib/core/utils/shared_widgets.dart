// file: lib/utils/page_transition.dart
import 'package:flutter/material.dart';

PageRouteBuilder createPageTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end);
      var curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
      var offsetAnimation = tween.animate(curvedAnimation);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

// file: lib/widgets/text_form_field_widget.dart
Widget customTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData prefixIcon,
  required String? Function(String?) validator,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.blue),
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    validator: validator,
  );
}

Widget vSpacer(double height) {
  return SizedBox(
    height: height,
  );
}
