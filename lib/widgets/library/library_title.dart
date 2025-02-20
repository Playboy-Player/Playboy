import 'package:flutter/material.dart';

class MLibraryTitle extends StatelessWidget {
  const MLibraryTitle({
    super.key,
    required this.title,
    this.trailing = const SizedBox(),
  });

  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
