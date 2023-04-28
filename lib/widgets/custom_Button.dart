import 'package:flutter/material.dart';

Widget customButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return ElevatedButton(
    onPressed: onClick,
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Text(title),
      ],
    ),
  );
}
