import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
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
                '扫描选项',
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
                AppStorage().updateMusicPage();
              },
              leading: const Icon(Icons.refresh),
              title: const Text('重新扫描视频库和音乐库'),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              onTap: () {
                AppStorage().updateVideoPage();
              },
              leading: const Icon(Icons.video_library),
              title: const Text('重新扫描视频库'),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              onTap: () {
                AppStorage().updateMusicPage();
              },
              leading: const Icon(Icons.library_music),
              title: const Text('重新扫描音乐库'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                '路径设置',
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Text(
                    '音乐文件夹',
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
                          AppStorage().settings.musicPaths.add(res);
                          AppStorage().saveSettings();
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('添加'),
                    ),
                  )),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildPathCard(AppStorage().settings.musicPaths[index],
                    colorScheme, AppStorage().settings.musicPaths),
              );
            },
            itemCount: AppStorage().settings.musicPaths.length,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Text(
                    '视频文件夹',
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
                      label: const Text('添加'),
                    ),
                  )),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  const Text(
                    '收藏夹',
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
                          AppStorage().settings.favouritePaths.add(res);
                          AppStorage().saveSettings();
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('添加'),
                    ),
                  )),
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
                    AppStorage().settings.favouritePaths),
              );
            },
            itemCount: AppStorage().settings.favouritePaths.length,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                '截图文件夹',
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
                    borderRadius: BorderRadius.circular(14)),
                color: colorScheme.secondaryContainer.withOpacity(0.4),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppStorage().settings.screenshotPath,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () async {
                                var res = await FilePicker.platform
                                    .getDirectoryPath(lockParentWindow: true);
                                if (res != null) {
                                  AppStorage().settings.screenshotPath = res;
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: const Text(
                '下载文件夹',
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
                    borderRadius: BorderRadius.circular(14)),
                color: colorScheme.secondaryContainer.withOpacity(0.4),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppStorage().settings.downloadPath,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                      Expanded(
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
              padding: const EdgeInsets.all(12),
              child: Text(
                '应用数据',
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
              title: const Text('打开应用数据文件夹'),
              subtitle: Text(AppStorage().dataPath),
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
              title: const Text('恢复默认设置'),
              subtitle: const Text('不可恢复,重启后生效'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildPathCard(
      String path, ColorScheme colorScheme, List<String> dst) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: colorScheme.secondaryContainer.withOpacity(0.4),
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
            )),
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
                ))
          ],
        ),
      ),
    );
  }
}
