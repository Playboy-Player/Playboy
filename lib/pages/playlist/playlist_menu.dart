import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:playboy/widgets/menu_item.dart';

List<Widget> buildCommonPlaylistMenuItems(
  BuildContext context,
  ColorScheme colorScheme,
  PlaylistItem item,
) {
  return [
    MMenuItem(
      icon: Icons.play_circle_outline_rounded,
      label: context.l10n.play,
      onPressed: () {
        AppStorage().closeMedia();
        AppStorage().openPlaylist(item, false);
      },
    ),
    MMenuItem(
      icon: Icons.shuffle,
      label: context.l10n.shuffle,
      onPressed: () {
        AppStorage().closeMedia();
        AppStorage().openPlaylist(
          item,
          true,
        );
      },
    ),
    const MMenuItem(
      icon: Icons.add_circle_outline,
      label: '追加到播放列表',
      onPressed: null,
      // () {
      //   AppStorage().appendPlaylist(
      //     item,
      //   );
      // },
    ),
    MMenuItem(
      icon: Icons.share,
      label: context.l10n.export,
      onPressed: () async {
        final originalFile = File(
          '${AppStorage().dataPath}/playlists/${item.uuid}.json',
        );
        String? newFilePath = await FilePicker.platform.saveFile(
          dialogTitle: context.l10n.saveAs,
          fileName: '${item.uuid}.json',
        );

        if (newFilePath != null) {
          final newFile = File(newFilePath);

          await originalFile.copy(newFile.path);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${context.l10n.fileSavedAs}: $newFilePath',
              ),
            ),
          );
        }
      },
    ),
  ];
}
