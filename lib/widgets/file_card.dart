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
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: InkWell(
              onTap: () {
                if (extension(source) == '.mp4') {
                  AppStorage().closeMedia();
                  if (!context.mounted) return;
                  AppStorage().openMedia(
                      PlayItem(source: source, cover: null, title: source));

                  Navigator.of(context, rootNavigator: true)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const MPlayer(),
                    ),
                  )
                      .then((value) {
                    AppStorage().updateStatus();
                  });
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: colorScheme.secondaryContainer,
                ),
                child: Icon(
                  icon ?? Icons.insert_drive_file_outlined,
                  color: colorScheme.secondary,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Tooltip(
            message: name,
            waitDuration: const Duration(seconds: 1),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
