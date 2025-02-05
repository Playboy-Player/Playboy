import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/pages/file/file_explorer.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.source,
    required this.icon,
  });
  final String source;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    String name = basename(source);

    return MInteractiveWrapper(
      menuController: MenuController(),
      menuChildren: const [],
      onTap: () {
        pushPage(context, FileExplorer(path: source));
      },
      borderRadius: 20,
      child: MCoverCard(
        cover: null,
        title: name,
        aspectRatio: 1,
        icon: icon ?? Icons.folder,
      ),
    );
  }
}
