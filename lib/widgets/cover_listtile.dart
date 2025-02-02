import 'package:flutter/material.dart';
import 'package:playboy/widgets/cover.dart';

class MCoverListTile extends StatelessWidget {
  const MCoverListTile({
    super.key,
    required this.onTap,
    required this.height,
    required this.icon,
    required this.cover,
    required this.aspectRatio,
    required this.label,
    required this.actions,
  });

  final Function()? onTap;
  final double height;

  final IconData icon;
  final String? cover;
  final double aspectRatio;
  final String label;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: MCover(
                cover: cover,
                aspectRatio: aspectRatio,
                icon: icon,
                iconSize: height / 2,
                borderRadius: 12,
                colorScheme: colorScheme,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            ...actions,
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
