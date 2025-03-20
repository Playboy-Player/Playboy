import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

List<Widget> buildCommonPlaylistMenuItems(
  BuildContext context,
  ColorScheme colorScheme,
  PlaylistItem item,
) {
  return [
    MMenuItem(
      icon: Icons.play_circle_outline_rounded,
      label: '播放'.l10n,
      onPressed: () {
        App().closeMedia();
        App().openPlaylist(item, false);
      },
    ),
    MMenuItem(
      icon: Icons.shuffle,
      label: '随机播放'.l10n,
      onPressed: () {
        App().closeMedia();
        App().openPlaylist(
          item,
          true,
        );
      },
    ),
    MMenuItem(
      icon: Icons.add_circle_outline,
      label: '追加到播放列表'.l10n,
      onPressed: null,
      // () {
      //   AppStorage().appendPlaylist(
      //     item,
      //   );
      // },
    ),
    MMenuItem(
      icon: Icons.share,
      label: '导出'.l10n,
      onPressed: () async {
        final originalFile = File(
          '${App().dataPath}/playlists/${item.title}.json',
        );
        String? newFilePath = await FilePicker.platform.saveFile(
          dialogTitle: '另存为',
          fileName: '${item.title}.json',
        );

        if (newFilePath != null) {
          final newFile = File(newFilePath);

          await originalFile.copy(newFile.path);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '已经保存到: $newFilePath',
              ),
            ),
          );
        }
      },
    ),
  ];
}
