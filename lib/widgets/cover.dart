import 'dart:io';

import 'package:flutter/material.dart';

class MCover extends StatelessWidget {
  const MCover({
    super.key,
    required this.cover,
    required this.aspectRatio,
    required this.icon,
    required this.iconSize,
    required this.borderRadius,
    required this.colorScheme,
  });

  final String? cover;
  final double aspectRatio;
  final IconData icon;
  final double iconSize;
  final double borderRadius;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = colorScheme.primaryContainer.withValues(alpha: 0.4);
    Color foregroundColor = colorScheme.onPrimaryContainer;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: cover == null || !File(cover!).existsSync()
          ? Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: backgroundColor,
              ),
              child: Icon(
                icon,
                color: foregroundColor,
                size: iconSize,
              ),
            )
          : Ink(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: backgroundColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(cover!)),
                ),
              ),
            ),
    );
  }
}
