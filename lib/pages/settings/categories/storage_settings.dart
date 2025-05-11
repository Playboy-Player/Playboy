import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/widgets/path_setting_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class StorageSettingsPage extends StatefulWidget {
  const StorageSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _StorageSettingsPageState();
}

class _StorageSettingsPageState extends State<StorageSettingsPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '扫描选项'.l10n,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () {
                  App().actions['rescanLibrary']?.call();
                },
                leading: const Icon(Icons.scanner),
                title: Text('重新扫描媒体库'.l10n),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '扫描位置'.l10n,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            var res = await FilePicker.platform
                                .getDirectoryPath(lockParentWindow: true);
                            if (res != null) {
                              App().settings.videoPaths.add(res);
                              App().saveSettings();
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text('添加'.l10n),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                String path = App().settings.videoPaths[index];
                return PathSettingCard(
                  path: path,
                  actions: [
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          launchUrl(
                            Uri.directory(App().settings.videoPaths[index]),
                          );
                        },
                        icon: Icon(
                          Icons.folder_outlined,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          App().settings.videoPaths.remove(path);
                          App().saveSettings();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: App().settings.videoPaths.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '收藏夹'.l10n,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            var res = await FilePicker.platform
                                .getDirectoryPath(lockParentWindow: true);
                            if (res != null) {
                              App().settings.favouritePaths.add(res);
                              App().saveSettings();
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text('添加'.l10n),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                String path = App().settings.favouritePaths[index];
                return PathSettingCard(
                  path: path,
                  actions: [
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          launchUrl(
                            Uri.directory(App().settings.favouritePaths[index]),
                          );
                        },
                        icon: Icon(
                          Icons.folder_outlined,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          App().settings.favouritePaths.remove(path);
                          App().saveSettings();
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                );
              },
              itemCount: App().settings.favouritePaths.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  '截图保存位置'.l10n,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            PathSettingCard(
              path: App().settings.screenshotPath,
              actions: [
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: () async {
                      var res = await FilePicker.platform
                          .getDirectoryPath(lockParentWindow: true);
                      if (res != null) {
                        App().settings.screenshotPath = res;
                        App().saveSettings();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
                )
              ],
            ).toSliver(),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '应用数据'.l10n,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () {
                  launchUrl(Uri.directory(App().dataPath));
                },
                leading: const Icon(Icons.folder_outlined),
                title: Text('打开应用数据文件夹'.l10n),
                subtitle: Text(
                  App().dataPath,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () {
                  App().dialog(
                    (context) => AlertDialog(
                      title: const Text('恢复默认设置'),
                      content: Text(
                        '重置所有设置并清除收藏夹列表, 但不会删除播放列表和本地文件, 是否继续?\n执行此操作后, 请手动重启应用'
                            .l10n,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('取消'.l10n),
                        ),
                        TextButton(
                          onPressed: () {
                            var f =
                                File('${App().dataPath}/config/settings.json');
                            if (f.existsSync()) {
                              f.deleteSync();
                            }
                            Navigator.pop(context);
                          },
                          child: Text('确定'.l10n),
                        ),
                      ],
                    ),
                  );
                },
                leading: const Icon(Icons.cleaning_services),
                title: Text('恢复默认设置'.l10n),
                subtitle: Text('重启应用后生效'.l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
