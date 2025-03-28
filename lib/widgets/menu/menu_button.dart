import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.menuChildren,
    this.style,
    this.constraints,
    this.icon = Icons.more_vert,
    this.tooltip,
  });

  final List<Widget> menuChildren;
  final ButtonStyle? style;
  final BoxConstraints? constraints;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          style: style,
          constraints: constraints,
          tooltip: tooltip ?? '菜单'.l10n,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(icon),
        );
      },
      menuChildren: menuChildren,
    );
  }
}
