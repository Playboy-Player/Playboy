import 'package:flutter/material.dart';

class MLibraryTitle extends StatelessWidget {
  const MLibraryTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
