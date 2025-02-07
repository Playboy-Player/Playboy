import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/menu_item.dart';

List<Widget> buildPlayerMenu() {
  return [
    const SizedBox(height: 10),
    MMenuItem(
      icon: Icons.cut,
      label: '截图'.l10n,
      onPressed: () async {
        if (AppStorage().playingTitle == 'Not Playing') return;
        var image = await AppStorage().playboy.screenshot();
        if (image != null) {
          var file = File(
            '${AppStorage().settings.screenshotPath}/${getCurrentTimeString()}.png',
          );
          await file.writeAsBytes(image);
        }
      },
    ),
    MMenuItem(
      icon: Icons.cut,
      label: '将当前画面设为封面'.l10n,
      onPressed: () async {
        if (AppStorage().playingTitle == 'Not Playing') return;
        var image = await AppStorage().playboy.screenshot();
        if (image != null) {
          var file = File('${AppStorage().playingCover}');
          await file.writeAsBytes(image);
          final ImageProvider imageProvider = FileImage(file);
          imageProvider.evict();
        }
        AppStorage().updateStatus();
      },
    ),
    MMenuItem(icon: Icons.flash_on, label: '设置播放速度'.l10n, onPressed: null),
    const Divider(),
    MMenuItem(icon: Icons.info_outline, label: '属性'.l10n, onPressed: null),
    const SizedBox(height: 10),
  ];
}
