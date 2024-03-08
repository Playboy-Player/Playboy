import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/pages/media/m_player.dart';

class FileCard extends StatelessWidget {
  const FileCard({super.key, required this.source, required this.icon});
  final String source;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    String name = basename(source);
    late final colorScheme = Theme.of(context).colorScheme;
    return Card(
      // surfaceTintColor: Colors.transparent,
      elevation: 1.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          if (extension(source) == '.mp4') {
            AppStorage().closeMedia();
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => MPlayer(
                  info: PlayItem(source: source, cover: null, title: source),
                  currentMedia: false,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: colorScheme.tertiaryContainer,
                ),
                child: Icon(
                  icon ?? Icons.insert_drive_file_outlined,
                  color: colorScheme.onTertiaryContainer,
                  size: 60,
                ),
              ),
            ),
            Expanded(
              child: Center(
                  child: Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                ),
              )),
            )
          ],
        ),
      ),
    );
  }
}
