import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/widgets/menu_item.dart';
import 'package:playboy/widgets/playlist_picker.dart';

List<Widget> buildMediaMenuItems(
  BuildContext context,
  ColorScheme colorScheme,
  PlayItem item,
) {
  return [
    const SizedBox(height: 10),
    MMenuItem(
      icon: Icons.play_arrow_outlined,
      label: '播放器播放',
      onPressed: () {
        AppStorage().closeMedia();
        AppStorage().openMedia(item);

        if (!context.mounted) return;
        pushRootPage(
          context,
          const MPlayer(),
        );
        AppStorage().updateStatus();
      },
    ),
    MMenuItem(
      icon: Icons.play_circle_outline_rounded,
      label: '背景播放',
      onPressed: () {
        AppStorage().closeMedia();
        AppStorage().openMedia(item);
      },
    ),
    const MMenuItem(
      icon: Icons.last_page,
      label: '最后播放',
      onPressed: null,
    ),
    MMenuItem(
      icon: Icons.add_circle_outline,
      label: '添加到播放列表',
      onPressed: () {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            // surfaceTintColor: Colors.transparent,
            title: const Text('添加到播放列表'),
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
                          AppStorage().playlists[indexList],
                          item,
                        );
                        Navigator.pop(context);
                      },
                      child: PlaylistPickerItem(
                        info: AppStorage().playlists[indexList],
                      ),
                    ),
                  );
                },
                itemCount: AppStorage().playlists.length,
              ),
            ),
          ),
        );
      },
    ),
    const Divider(),
    const MMenuItem(
      icon: Icons.design_services_outlined,
      label: '修改封面',
      onPressed: null,
    ),
    const MMenuItem(
      icon: Icons.info_outline,
      label: '属性',
      onPressed: null,
    ),
    const SizedBox(height: 10),
  ];
}
