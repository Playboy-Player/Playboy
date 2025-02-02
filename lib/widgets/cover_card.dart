import 'package:flutter/material.dart';
import 'package:playboy/widgets/cover.dart';

class MCoverCard extends StatelessWidget {
  const MCoverCard({
    super.key,
    required this.icon,
    required this.cover,
    required this.aspectRatio,
    required this.title,
  });

  final IconData icon;
  final String? cover;
  final double aspectRatio;
  final String title;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: MCover(
              cover: cover,
              aspectRatio: aspectRatio,
              icon: icon,
              iconSize: 50,
              borderRadius: 20,
              colorScheme: colorScheme,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Tooltip(
              message: title,
              waitDuration: const Duration(seconds: 1),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
