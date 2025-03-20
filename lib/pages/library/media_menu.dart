import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/pages/library/common_media_menu.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

List<Widget> buildMediaMenuItems(
  Function callback,
  BuildContext context,
  ColorScheme colorScheme,
  PlayItem item,
) {
  return [
    const SizedBox(height: 10),
    ...buildCommonMediaMenuItems(context, colorScheme, item),
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
          var savePath = item.cover;
          var originalFile = File(coverPath);
          var newFile = File(savePath);
          // item.cover = savePath;
          await originalFile.copy(newFile.path).then((_) {
            // final ImageProvider imageProvider = FileImage(newFile);
            // imageProvider.evict();
            // state.setState(() {});
            callback();
          });
        }
      },
    ),
    MMenuItem(
      icon: Icons.cleaning_services,
      label: '清除封面'.l10n,
      onPressed: () async {
        var file = File(item.cover);
        if (await file.exists()) {
          file.delete();
          final ImageProvider imageProvider = FileImage(file);
          imageProvider.evict();
        }
        // setState(() {});
        callback();
      },
    ),
    MMenuItem(
      icon: Icons.auto_awesome_outlined,
      label: '生成字幕',
      onPressed: () async {
        // if (App().settings.model != '') {
        //   SubtitleGenerator subGenerator = SubtitleGenerator(
        //     App().settings.model,
        //   );
        //   var subtitle = await subGenerator.genSubtitle(item.source);
        //   debugPrint("Generated subtitle: $subtitle");
        //   App().playboy.setSubtitleTrack(SubtitleTrack.data(subtitle));
        // }
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
