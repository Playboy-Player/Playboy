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
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        // SliverToBoxAdapter(
        //   child: Container(
        //     padding: const EdgeInsets.all(12),
        //     child: const Text(
        //       '扫描选项',
        //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        //     ),
        //   ),
        // ),
        // SliverToBoxAdapter(
        //   child: ListTile(
        //     onTap: () {
        //       AppStorage().updateStatus();
        //     },
        //     leading: const Icon(Icons.refresh),
        //     title: const Text('重新扫描媒体库'),
        //   ),
        // ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  '音乐库路径',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var res = await FilePicker.platform
                          .getDirectoryPath(lockParentWindow: true);
                      if (res != null) {
                        AppStorage().settings.musicPaths.add(res);
                        AppStorage().saveSettings();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add_circle))
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:
                  _buildMusicPathCard(AppStorage().settings.musicPaths[index]),
            );
          },
          itemCount: AppStorage().settings.musicPaths.length,
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  '视频库路径',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      var res = await FilePicker.platform
                          .getDirectoryPath(lockParentWindow: true);
                      if (res != null) {
                        AppStorage().settings.videoPaths.add(res);
                        AppStorage().saveSettings();
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.add_circle))
              ],
            ),
          ),
        ),
        SliverList.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:
                  _buildVideoPathCard(AppStorage().settings.videoPaths[index]),
            );
          },
          itemCount: AppStorage().settings.videoPaths.length,
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '截图路径',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
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
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppStorage().settings.screenshotPath),
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
                            icon: const Icon(
                              Icons.edit,
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
              '下载路径',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
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
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppStorage().settings.downloadPath),
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
                            icon: const Icon(
                              Icons.edit,
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
                color: Theme.of(context).colorScheme.primary,
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
    ));
  }

  Widget _buildMusicPathCard(String path) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(path),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      launchUrl(Uri.directory(path));
                    },
                    icon: const Icon(
                      Icons.folder_outlined,
                    )),
                IconButton(
                    onPressed: () {
                      AppStorage().settings.musicPaths.remove(path);
                      AppStorage().saveSettings();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    )),
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

  Widget _buildVideoPathCard(String path) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(path),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      launchUrl(Uri.directory(path));
                    },
                    icon: const Icon(
                      Icons.folder_outlined,
                    )),
                IconButton(
                    onPressed: () {
                      AppStorage().settings.videoPaths.remove(path);
                      AppStorage().saveSettings();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                    )),
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
