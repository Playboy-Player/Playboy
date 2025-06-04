import 'package:flutter/material.dart';

class SettingsPath extends StatelessWidget {
  const SettingsPath({
    super.key,
    required this.path,
    required this.actions,
  });

  final String path;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  path,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              ...actions,
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
