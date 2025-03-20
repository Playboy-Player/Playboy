import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/pages/playlist/common_playlist_menu.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

List<Widget> buildPlaylistMenuItems(
  Function callback,
  BuildContext context,
  ColorScheme colorScheme,
  PlaylistItem item,
) {
  TextEditingController editingController = TextEditingController();
  return [
    const SizedBox(height: 10),
    ...buildCommonPlaylistMenuItems(
      context,
      colorScheme,
      item,
    ),
    const Divider(),
    MMenuItem(
      icon: Icons.design_services_outlined,
      label: '修改封面'.l10n,
      onPressed: () async {
        String? coverPath =
            await FilePicker.platform.pickFiles(type: FileType.image).then(
          (result) {
            return result?.files.single.path;
          },
        );
        if (coverPath != null) {
          var savePath = '${App().dataPath}/playlists/${item.title}.cover.jpg';
          var originalFile = File(coverPath);
          var newFile = File(savePath);
          await originalFile.copy(newFile.path).then(
            (_) {
              final ImageProvider imageProvider = FileImage(newFile);
              imageProvider.evict();
              callback();
            },
          );
        }
      },
    ),
    MMenuItem(
      icon: Icons.cleaning_services,
      label: '清除封面'.l10n,
      onPressed: () async {
        var cover = File(item.cover);
        if (await cover.exists()) {
          await cover.delete();
        }
        callback();
      },
    ),
    MMenuItem(
      icon: Icons.drive_file_rename_outline,
      label: '重命名'.l10n,
      onPressed: () {
        editingController.clear();
        editingController.text = item.title;
        App().dialog(
          (BuildContext context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: Text('重命名'.l10n),
            content: TextField(
              autofocus: true,
              maxLines: 1,
              controller: editingController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: '名称'.l10n,
              ),
              onSubmitted: (value) {
                LibraryHelper.renamePlaylist(
                  item,
                  value,
                );
                callback();
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'.l10n),
              ),
              TextButton(
                onPressed: () {
                  LibraryHelper.renamePlaylist(
                    item,
                    editingController.text,
                  );
                  callback();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('确定'.l10n),
              ),
            ],
          ),
        );
      },
    ),
    MMenuItem(
      icon: Icons.delete_outline,
      label: '删除'.l10n,
      onPressed: () {
        App().dialog(
          (context) {
            return AlertDialog(
              title: Text('操作确认'.l10n),
              content: Text('确定要删除播放列表吗?'.l10n),
              actions: [
                TextButton(
                  child: Text('取消'.l10n),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('确定'.l10n),
                  onPressed: () {
                    LibraryHelper.deletePlaylist(
                      item,
                    );
                    // AppStorage().playlists.removeAt(index);
                    App().playlists.remove(item);
                    callback();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    ),
    const Divider(),
    MMenuItem(
      icon: Icons.info_outline,
      label: '属性'.l10n,
      onPressed: null,
    ),
    const SizedBox(height: 10),
  ];
}
