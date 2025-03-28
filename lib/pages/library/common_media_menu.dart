import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/menu/menu_item.dart';
import 'package:playboy/widgets/playlist_picker.dart';

List<Widget> buildCommonMediaMenuItems(
  BuildContext context,
  ColorScheme colorScheme,
  PlayItem item,
) {
  return [
    MMenuItem(
      icon: Icons.open_in_new,
      label: '播放器播放'.l10n,
      onPressed: () {
        App().openMedia(item);
        App().actions['togglePlayer']?.call();
      },
    ),
    MMenuItem(
      icon: Icons.play_circle_outline_rounded,
      label: '播放'.l10n,
      onPressed: () {
        App().openMedia(item);
      },
    ),
    MMenuItem(
      icon: Icons.navigate_next_outlined,
      label: '插播'.l10n,
      onPressed: null,
    ),
    MMenuItem(
      icon: Icons.last_page,
      label: '最后播放'.l10n,
      onPressed: null,
    ),
    MMenuItem(
      icon: Icons.add_circle_outline,
      label: '添加到播放列表'.l10n,
      onPressed: () {
        App().dialog(
          (context) => AlertDialog(
            // surfaceTintColor: Colors.transparent,
            title: Text('添加到播放列表'.l10n),
            content: SizedBox(
              width: 300,
              height: 300,
              child: ListView.builder(
                itemBuilder: (context, indexList) {
                  return SizedBox(
                    height: 60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        LibraryHelper.addItemToPlaylist(
                          App().playlists[indexList],
                          item,
                        );
                        Navigator.pop(context);
                      },
                      child: PlaylistPickerItem(
                        info: App().playlists[indexList],
                      ),
                    ),
                  );
                },
                itemCount: App().playlists.length,
              ),
            ),
          ),
        );
      },
    ),
  ];
}
