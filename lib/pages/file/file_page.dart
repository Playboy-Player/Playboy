import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/biliapi/bilibili_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/pages/file/download_page.dart';
import 'package:playboy/pages/media/bili_player.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/widgets/folder_card.dart';
import 'package:provider/provider.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key, required this.mark});
  final int mark;

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // int n = AppStorage().settings.musicPaths.length;
    int n = context.read<AppStorage>().settings.musicPaths.length;
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 150).round(), 2);
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.08), colorScheme.surface);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: Text(
                '文件',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              // background:
            ),
            pinned: true,
            expandedHeight: 80,
            actions: [
              Container(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: FloatingActionButton.extended(
                  isExtended: MediaQuery.of(context).size.width > 500,
                  heroTag: 'open_file',
                  tooltip: '打开系统文件管理器',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () async {
                    var res = await FilePicker.platform
                        .pickFiles(type: FileType.media);
                    if (res != null) {
                      String link = res.files.single.path!;
                      _openLink(link, false);
                    }
                  },
                  icon: const Icon(Icons.insert_drive_file_outlined),
                  label: const Text('选取文件'),
                ),
              ),
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            _buildOption(Icons.movie_filter_outlined, '打开视频链接', () {
              editingController.clear();
              showDialog(
                barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                useRootNavigator: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  surfaceTintColor: Colors.transparent,
                  title: const Text('打开视频链接'),
                  content: TextField(
                    autofocus: true,
                    maxLines: 1,
                    controller: editingController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.link),
                      border: OutlineInputBorder(),
                      labelText: '本地或网络地址',
                    ),
                    onSubmitted: (value) async {
                      if (value.startsWith('BV')) {
                        _openLink(value, true);
                      } else {
                        _openLink(value, false);
                      }
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
                        if (editingController.text.startsWith('BV')) {
                          _openLink(editingController.text, true);
                        } else {
                          _openLink(editingController.text, false);
                        }
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            }),
            _buildOption(Icons.download, '下载管理', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DownloadPage()));
            }),
          ])),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text(
                '浏览',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                // childAspectRatio: 10 / 9,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index >= n) {
                    return FolderCard(
                      source: AppStorage().settings.videoPaths[index - n],
                      icon: Icons.video_library,
                    );
                  } else {
                    return FolderCard(
                      source: AppStorage().settings.musicPaths[index],
                      icon: Icons.library_music,
                    );
                  }
                },
                childCount: n + AppStorage().settings.videoPaths.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(IconData? icon, String text, Function()? tap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: tap,
    );
  }

  void _openLink(String source, bool isBv) async {
    AppStorage().closeMedia();
    if (isBv) {
      final info = await BilibiliHelper.getVideoInfo(source);
      final playInfo = await BilibiliHelper.getVideoStream(source, info.cid);
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(
              builder: (context) => BiliPlayer(
                    videoInfo: info,
                    playInfo: playInfo,
                  )))
          .then((value) {
        AppStorage().updateStatus();
      });
    } else {
      if (!context.mounted) return;
      AppStorage()
          .openMedia(PlayItem(source: source, cover: null, title: source));
      Navigator.of(context, rootNavigator: true)
          .push(
        MaterialPageRoute(
          builder: (context) => const MPlayer(),
        ),
      )
          .then((value) {
        AppStorage().updateStatus();
      });
    }
  }
}
