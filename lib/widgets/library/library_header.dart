import 'package:flutter/material.dart';

class MLibraryHeader extends StatelessWidget {
  const MLibraryHeader({
    super.key,
    required this.title,
    required this.actions,
  });

  final List<Widget>? actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsetsDirectional.only(
          start: 16,
          bottom: 16,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      pinned: true,
      expandedHeight: 80,
      collapsedHeight: 60,
      actions: actions,
    );
  }
}
