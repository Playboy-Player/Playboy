import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.menuChildren,
  });

  final List<Widget> menuChildren;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          tooltip: '菜单'.l10n,
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
