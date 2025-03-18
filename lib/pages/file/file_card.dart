import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/pages/library/common_media_menu.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';

class FileCard extends StatelessWidget {
  const FileCard({
    super.key,
    required this.source,
    required this.icon,
  });
  final String source;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    String name = basename(source);

    return MInteractiveWrapper(
      menuController: MenuController(),
      menuChildren: [
        const SizedBox(height: 10),
        ...buildCommonMediaMenuItems(
          context,
          colorScheme,
          PlayItem(
            source: source,
            title: name,
          ),
        ),
        const SizedBox(height: 10),
      ],
      onTap: () {
        if (LibraryHelper.supportFormats.contains(extension(source))) {
          App().closeMedia();
          if (!context.mounted) return;
          App().openMedia(
            PlayItem(source: source, title: source),
          );

          App().actions['togglePlayer']?.call();
        }
      },
      borderRadius: 20,
      child: MCoverCard(
        cover: null,
        title: name,
        aspectRatio: 1,
        icon: icon ?? Icons.insert_drive_file_outlined,
      ),
    );
  }
}
