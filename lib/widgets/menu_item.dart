import 'package:flutter/material.dart';

class MMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onPressed;

  const MMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      leadingIcon: Icon(
        icon,
        size: 18,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(label),
      ),
    );
  }
}
