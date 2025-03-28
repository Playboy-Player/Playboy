import 'package:flutter/material.dart';

class AppTitleBar extends StatefulWidget {
  const AppTitleBar({
    super.key,
    this.leftCaptionButton = false,
  });

  final bool leftCaptionButton;

  @override
  State<AppTitleBar> createState() => _AppTitleBarState();
}

class _AppTitleBarState extends State<AppTitleBar> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
