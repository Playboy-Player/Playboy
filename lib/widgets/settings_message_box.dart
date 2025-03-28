import 'package:flutter/material.dart';

class SettingsMessageBox extends StatelessWidget {
  const SettingsMessageBox({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: ShapeDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: SizedBox(
        height: 50,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            message,
            style: TextStyle(color: colorScheme.onPrimaryContainer),
          ),
        ),
      ),
    );
  }
}
