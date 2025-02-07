import 'package:flutter/material.dart';

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
          tooltip: '菜单',
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
