import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/icon_switch_listtile.dart';

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
                  App().updateVideoPage();
                },
                leading: const Icon(Icons.scanner),
                title: Text('重新扫描媒体库'.l10n),
              ),
            ),
            MIconSwitchListTile(
              icon: Icons.photo,
              label: '扫描媒体时截取封面 (WIP)'.l10n,
              value: App().settings.getCoverOnScan,
              onChanged: (value) {
                setState(() {
                  App().settings.getCoverOnScan = value;
                });
                App().saveSettings();
              },
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildPathCard(App().settings.videoPaths[index],
                      colorScheme, App().settings.videoPaths),
                );
              },
              itemCount: App().settings.videoPaths.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '文件夹'.l10n,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildPathCard(
                    App().settings.favouritePaths[index],
                    colorScheme,
                    App().settings.favouritePaths,
                  ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            App().settings.screenshotPath,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  var res = await FilePicker.platform
                                      .getDirectoryPath(lockParentWindow: true);
                                  if (res != null) {
                                    App().settings.screenshotPath = res;
                                    App().saveSettings();
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                leading: const Icon(Icons.folder),
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
                  var f = File('${App().dataPath}/config/settings.json');
                  if (f.existsSync()) {
                    f.deleteSync();
                  }
                },
                leading: const Icon(Icons.restore),
                title: Text('恢复默认设置'.l10n),
                subtitle: Text('重启应用后生效'.l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathCard(
      String path, ColorScheme colorScheme, List<String> dst) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                path,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        launchUrl(Uri.directory(path));
                      },
                      icon: Icon(
                        Icons.folder_outlined,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        dst.remove(path);
                        App().saveSettings();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
