import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/pages/media/player_page.dart';
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
    String name = basename(source);

    return MInteractiveWrapper(
      menuController: MenuController(),
      menuChildren: const [],
      onTap: () {
        if (LibraryHelper.supportFormats.contains(extension(source))) {
          AppStorage().closeMedia();
          if (!context.mounted) return;
          AppStorage().openMedia(
            PlayItem(source: source, cover: null, title: source),
          );

          pushRootPage(
            context,
            const PlayerPage(),
          ).then((value) {
            AppStorage().updateStatus();
          });
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
