import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:playboy/pages/file/folder_card.dart';
import 'package:playboy/pages/media/player_page.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/library_header.dart';
import 'package:playboy/widgets/library_listtile.dart';
import 'package:playboy/widgets/library_title.dart';
// import 'package:provider/provider.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppStorage().updateFilePage = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    // int n = context.read<AppStorage>().settings.musicPaths.length;
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 150).round(), 2);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MLibraryHeader(
            title: context.l10n.files,
            actions: null,
          ),
          _buildLibraryOptions(),
          // const MLibraryTitle(title: '媒体库'),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   sliver: SliverGrid(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: cols,
          //       childAspectRatio: 5 / 6,
          //     ),
          //     delegate: SliverChildBuilderDelegate(
          //       (BuildContext context, int index) {
          //         if (index >= n) {
          //           return FolderCard(
          //             source: AppStorage().settings.videoPaths[index - n],
          //             icon: Icons.movie_filter,
          //           );
          //         } else {
          //           return FolderCard(
          //             source: AppStorage().settings.musicPaths[index],
          //             icon: Icons.music_note,
          //           );
          //         }
          //       },
          //       childCount: n + AppStorage().settings.videoPaths.length,
          //     ),
          //   ),
          // ),
          const MLibraryTitle(title: '收藏夹'),
          SliverPadding(
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
                      source: AppStorage().settings.downloadPath,
                      icon: Icons.file_download,
                    );
                  } else if (index == 1) {
                    return FolderCard(
                      source: AppStorage().settings.screenshotPath,
                      icon: Icons.photo,
                    );
                  } else {
                    return FolderCard(
                      source: AppStorage().settings.favouritePaths[index - 2],
                      icon: Icons.folder_special_rounded,
                    );
                  }
                },
                childCount: AppStorage().settings.favouritePaths.length + 2,
              ),
            ),
          ),
          const MLibraryTitle(title: '最近播放'),
          const MEmptyHolder(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryOptions() {
    return SliverList(
      delegate: SliverChildListDelegate([
        MLibraryListTile(
          icon: Icons.folder_open,
          title: '播放文件夹',
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
          title: '播放本地文件',
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
          icon: Icons.link,
          title: '播放网络串流',
          onTap: () {
            editingController.clear();
            showDialog(
              useRootNavigator: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                surfaceTintColor: Colors.transparent,
                title: const Text('打开网络串流'),
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
                    // if (value.startsWith('BV')) {
                    //   _openLink(value, true);
                    // } else {
                    //   _openLink(value, false);
                    // }
                    _openLink(value);
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () async {
                      // if (editingController.text.startsWith('BV')) {
                      //   _openLink(editingController.text, true);
                      // } else {
                      //   _openLink(editingController.text, false);
                      // }
                      _openLink(editingController.text);
                    },
                    child: const Text('确定'),
                  ),
                ],
              ),
            );
          },
        ),
        // MLibraryListTile(
        //   icon: Icons.file_download_outlined,
        //   title: '下载管理',
        //   onTap: () {
        //     pushPage(context, const DownloadPage());
        //   },
        // ),
        // const MLibraryListTile(
        //   icon: Icons.live_tv,
        //   title: 'BV Tools',
        //   onTap: null,
        // ),
      ]),
    );
  }

  void _openLink(String source) async {
    // AppStorage().closeMedia();
    // if (isBv) {
    //   final info = await BilibiliHelper.getVideoInfo(source);
    //   final playInfo = await BilibiliHelper.getVideoStream(source, info.cid);
    //   if (!mounted) return;
    //   Navigator.of(context, rootNavigator: true)
    //       .push(MaterialPageRoute(
    //           builder: (context) => BiliPlayer(
    //                 videoInfo: info,
    //                 playInfo: playInfo,
    //               )))
    //       .then((value) {
    //     AppStorage().updateStatus();
    //   });
    // } else {
    //   if (!context.mounted) return;
    //   AppStorage()
    //       .openMedia(PlayItem(source: source, cover: null, title: source));
    //   Navigator.of(context, rootNavigator: true)
    //       .push(
    //     MaterialPageRoute(
    //       builder: (context) => const MPlayer(),
    //     ),
    //   )
    //       .then((value) {
    //     AppStorage().updateStatus();
    //   });
    // }
    if (!context.mounted) return;
    AppStorage().closeMedia();
    AppStorage().openMedia(
      PlayItem(source: source, cover: null, title: source),
    );

    pushRootPage(
      context,
      const PlayerPage(),
    ).then((value) {
      AppStorage().updateStatus();
    });
  }
}
