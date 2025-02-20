import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

List<Widget> buildPlayerMenu() {
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
      onPressed: null,
    ),
    MMenuItem(
      icon: Icons.folder_open,
      label: '打开文件夹'.l10n,
      onPressed: null,
    ),
    MMenuItem(
      icon: Icons.link,
      label: '打开URL'.l10n,
      onPressed: null,
    ),
    const Divider(),
    MMenuItem(icon: Icons.info_outline, label: '属性'.l10n, onPressed: null),
    const SizedBox(height: 10),
  ];
}
