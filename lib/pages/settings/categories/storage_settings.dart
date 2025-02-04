import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  context.l10n.scanOptions,
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
                  AppStorage().updateVideoPage();
                },
                leading: const Icon(Icons.scanner),
                title: const Text('重新扫描媒体库'),
              ),
            ),
            SliverToBoxAdapter(
              child: SwitchListTile(
                value: AppStorage().settings.getCoverOnScan,
                onChanged: (value) {
                  setState(() {
                    AppStorage().settings.getCoverOnScan = value;
                  });
                  AppStorage().saveSettings();
                },
                title: const Row(
                  children: [
                    Icon(Icons.photo),
                    SizedBox(width: 12),
                    Text('扫描媒体时截取封面'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    const Text(
                      '媒体库',
                      style: TextStyle(
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
                              AppStorage().settings.videoPaths.add(res);
                              AppStorage().saveSettings();
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.l10n.add),
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
                  child: _buildPathCard(AppStorage().settings.videoPaths[index],
                      colorScheme, AppStorage().settings.videoPaths),
                );
              },
              itemCount: AppStorage().settings.videoPaths.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Text(
                      context.l10n.favorites,
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
                              AppStorage().settings.favouritePaths.add(res);
                              AppStorage().saveSettings();
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(context.l10n.add),
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
                    AppStorage().settings.favouritePaths[index],
                    colorScheme,
                    AppStorage().settings.favouritePaths,
                  ),
                );
              },
              itemCount: AppStorage().settings.favouritePaths.length,
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: const Text(
                  '截图保存位置',
                  style: TextStyle(
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
                            AppStorage().settings.screenshotPath,
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
                                          .getDirectoryPath(
                                              lockParentWindow: true);
                                      if (res != null) {
                                        AppStorage().settings.screenshotPath =
                                            res;
                                        AppStorage().saveSettings();
                                        setState(() {});
                                      }
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: colorScheme.onSecondaryContainer,
                                    )),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: const Text(
                  '下载保存位置',
                  style: TextStyle(
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
                            overflow: TextOverflow.ellipsis,
                            AppStorage().settings.downloadPath,
                            style: TextStyle(
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
                                    AppStorage().settings.downloadPath = res;
                                    AppStorage().saveSettings();
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
                              ),
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
                  context.l10n.appData,
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
                  launchUrl(Uri.directory(AppStorage().dataPath));
                },
                leading: const Icon(Icons.folder),
                title: Text(context.l10n.openAppDataFolder),
                subtitle: Text(
                  AppStorage().dataPath,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListTile(
                onTap: () {
                  var f = File('${AppStorage().dataPath}/config/settings.json');
                  if (f.existsSync()) {
                    f.deleteSync();
                  }
                },
                leading: const Icon(Icons.restore),
                title: Text(context.l10n.restoreDefaultSettings),
                subtitle: Text(context.l10n.irreversibleWarning),
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
                        AppStorage().saveSettings();
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
