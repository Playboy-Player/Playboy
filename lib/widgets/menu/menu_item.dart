import 'package:flutter/material.dart';

class MMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onPressed;
  final String keymap;

  const MMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.keymap = '',
  });

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 34,
      child: MenuItemButton(
        leadingIcon: Icon(
          icon,
          size: 18,
        ),
        onPressed: onPressed,
        trailingIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            keymap,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(label),
        ),
      ),
    );
  }
}
