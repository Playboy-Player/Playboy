import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/models/playitem.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

List<Widget> buildPlayerMenu(BuildContext context) {
  return [
    const SizedBox(height: 10),
    MMenuItem(icon: Icons.location_on, label: '跳转'.l10n, onPressed: null),
    MMenuItem(icon: Icons.flash_on, label: '设置播放速度'.l10n, onPressed: null),
    MMenuItem(
      icon: Icons.cut,
      label: '截图'.l10n,
      onPressed: () async {
        if (App().playingTitle == 'Not Playing') return;
        var image = await App().playboy.screenshot();
        if (image != null) {
          var file = File(
            '${App().settings.screenshotPath}/${getCurrentTimeString()}.png',
          );
          await file.writeAsBytes(image);
        }
      },
    ),
    MMenuItem(
      icon: Icons.cut,
      label: '将当前画面设为封面'.l10n,
      onPressed: () async {
        if (App().playingTitle == 'Not Playing') return;
        var image = await App().playboy.screenshot();
        if (image != null) {
          var file = File('${App().playingCover}');
          await file.writeAsBytes(image);
          final ImageProvider imageProvider = FileImage(file);
          imageProvider.evict();
        }
        App().updateStatus();
      },
    ),
    MMenuItem(icon: Icons.terminal, label: '自定义命令'.l10n, onPressed: null),
    MMenuItem(icon: Icons.alarm, label: '定时命令'.l10n, onPressed: null),
    const Divider(),
    MMenuItem(
      icon: Icons.file_open_outlined,
      label: '打开文件'.l10n,
      onPressed: () async {
        var res = await FilePicker.platform.pickFiles(lockParentWindow: true);
        if (res != null) {
          String link = res.files.single.path!;
          _openLink(link);
        }
      },
    ),
    MMenuItem(
      icon: Icons.folder_open,
      label: '打开文件夹'.l10n,
      onPressed: () async {
        var res = await FilePicker.platform.getDirectoryPath(
          lockParentWindow: true,
        );
        if (res != null) {
          String link = res;
          _openLink(link);
        }
      },
    ),
    MMenuItem(
      icon: Icons.link,
      label: '打开URL'.l10n,
      onPressed: () {
        var editingController = TextEditingController();
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: Text('播放网络串流'.l10n),
            content: TextField(
              autofocus: true,
              maxLines: 1,
              controller: editingController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
                labelText: 'URL',
              ),
              onSubmitted: (value) async {
                _openLink(value);
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
                onPressed: () async {
                  _openLink(editingController.text);
                },
                child: Text('确定'.l10n),
              ),
            ],
          ),
        );
      },
    ),
    const Divider(),
    MMenuItem(
        icon: Icons.info_outline,
        label: '属性'.l10n,
        onPressed: () {
          App().playboy.command(['keypress', 'SHIFT+I']);
        }),
    const SizedBox(height: 10),
  ];
}

void _openLink(String source) async {
  App().closeMedia();
  App().openMedia(
    PlayItem(source: source, cover: null, title: source),
  );
}
