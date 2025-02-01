import 'package:flutter/material.dart';

class MInteractiveWrapper extends StatelessWidget {
  const MInteractiveWrapper({
    super.key,
    required this.menuController,
    required this.menuChildren,
    required this.onTap,
    required this.borderRadius,
    required this.child,
  });

  final MenuController menuController;
  final List<Widget> menuChildren;
  final Widget child;
  final Function()? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        menuController.open(position: details.localPosition);
      },
      child: MenuAnchor(
        controller: menuController,
        menuChildren: menuChildren,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        ),
      ),
    );
  }
}
