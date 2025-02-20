import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/pages/file/file_explorer.dart';
import 'package:playboy/pages/file/folder_card.dart';
import 'package:playboy/pages/home.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/folding_holder.dart';
import 'package:playboy/widgets/library/library_header.dart';
import 'package:playboy/widgets/library/library_listtile.dart';
import 'package:playboy/widgets/library/library_title.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final TextEditingController _editingController = TextEditingController();

  bool _showLibraryLocations = true;
  bool _showFavLocations = true;

  @override
  void initState() {
    super.initState();
    App().updateFilePage = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 150).round(), 2);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MLibraryHeader(
            title: '文件'.l10n,
            actions: null,
          ),
          _buildLibraryOptions(),
          MLibraryTitle(
            title: '媒体库'.l10n,
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _showLibraryLocations = !_showLibraryLocations;
                });
              },
              icon: Icon(
                _showLibraryLocations
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          _showLibraryLocations
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 5 / 6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return FolderCard(
                          source: App().settings.videoPaths[index],
                          icon: Icons.folder_outlined,
                        );
                      },
                      childCount: App().settings.videoPaths.length,
                    ),
                  ),
                )
              : const MFoldingHolder().toSliver(),
          MLibraryTitle(
            title: '收藏夹'.l10n,
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _showFavLocations = !_showFavLocations;
                });
              },
              icon: Icon(
                _showFavLocations
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),
          _showFavLocations
              ? SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 5 / 6,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 0) {
                          return FolderCard(
                            source: App().settings.screenshotPath,
                            icon: Icons.photo_camera_back_outlined,
                          );
                        } else {
                          return FolderCard(
                            source: App().settings.favouritePaths[index - 1],
                            icon: Icons.folder_special_outlined,
                          );
                        }
                      },
                      childCount: App().settings.favouritePaths.length + 1,
                    ),
                  ),
                )
              : const MFoldingHolder().toSliver(),
          MLibraryTitle(title: '网络设备'.l10n),
          const MEmptyHolder().toSliver(),
          MLibraryTitle(title: '最近播放'.l10n),
          const MEmptyHolder().toSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        ],
      ),
    );
  }

  Widget _buildLibraryOptions() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          MLibraryListTile(
            icon: Icons.folder_open,
            title: '播放文件夹'.l10n,
            onTap: () async {
              var res = await FilePicker.platform.getDirectoryPath(
                lockParentWindow: true,
              );
              if (res != null) {
                String link = res;
                _openLink(link);
              }
            },
          ),
          MLibraryListTile(
            icon: Icons.insert_drive_file_outlined,
            title: '播放本地文件'.l10n,
            onTap: () async {
              var res =
                  await FilePicker.platform.pickFiles(lockParentWindow: true);
              if (res != null) {
                String link = res.files.single.path!;
                _openLink(link);
              }
            },
          ),
          MLibraryListTile(
            icon: Icons.explore_outlined,
            title: '浏览文件夹'.l10n,
            onTap: () {
              _editingController.clear();
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  title: const Text('浏览文件夹'),
                  content: TextField(
                    autofocus: true,
                    maxLines: 1,
                    controller: _editingController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: 'URL',
                    ),
                    onSubmitted: (value) async {
                      _exploreDirectory(value);
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
                        _exploreDirectory(_editingController.text);
                      },
                      child: Text('确定'.l10n),
                    ),
                  ],
                ),
              );
            },
          ),
          MLibraryListTile(
            icon: Icons.link,
            title: '播放网络串流'.l10n,
            onTap: () {
              _editingController.clear();
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  title: Text('播放网络串流'.l10n),
                  content: TextField(
                    autofocus: true,
                    maxLines: 1,
                    controller: _editingController,
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
                        _openLink(_editingController.text);
                      },
                      child: Text('确定'.l10n),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _exploreDirectory(String source) {
    pushPage(context, FileExplorer(path: source));
  }

  void _openLink(String source) async {
    if (!context.mounted) return;
    App().closeMedia();
    App().openMedia(
      PlayItem(source: source, cover: null, title: source),
    );

    // pushRootPage(
    //   context,
    //   const PlayerPage(),
    // ).then((value) {
    //   AppStorage().updateStatus();
    // });
    HomePage.switchView?.call();
  }
}
