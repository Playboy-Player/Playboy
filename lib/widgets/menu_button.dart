import 'package:flutter/material.dart';
import 'package:playboy/l10n/i10n.dart';

class MMenuButton extends StatelessWidget {
  const MMenuButton({
    super.key,
    required this.menuChildren,
  });

  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          tooltip: context.l10n.menu,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
      menuChildren: menuChildren,
    );
  }
}
