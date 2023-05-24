import 'package:flutter/material.dart';

Widget customButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
  required Color? buttonColor,
}) {
  return ElevatedButton(
    onPressed: onClick,
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonColor
    ),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(title),
      ],
    ),
  );
}
