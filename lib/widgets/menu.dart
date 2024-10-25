import 'package:flutter/material.dart';

Widget buildMenuItem(IconData icon, Widget label, Function()? onPressed) {
  return MenuItemButton(
    leadingIcon: Icon(
      icon,
      size: 18,
    ),
    onPressed: onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: label,
    ),
  );
}