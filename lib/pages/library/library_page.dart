import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/pages/home.dart';
import 'package:playboy/pages/library/media_menu.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/library_header.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/loading_holder.dart';
import 'package:playboy/widgets/menu_button.dart';
import 'package:playboy/widgets/menu_item.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<PlayItem> _playitems = [];
  bool _loaded = false;
  bool _gridview = true;
  bool _videoview = true;

  @override
  void initState() {
    super.initState();
    _loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MLibraryHeader(
            title: '媒体库'.l10n,
            actions: _buildLibraryActions(context),
          ),
          _buildLibraryview(context),
        ],
      ),
    );
  }

  void _loadLibrary() async {
    _playitems.addAll(
      await LibraryHelper.getMediaFromPaths(AppStorage().settings.videoPaths),
    );
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
    _gridview = !AppStorage().settings.videoLibListview;
    AppStorage().updateVideoPage = () async {
      setState(() {
        _loaded = false;
      });
      _playitems.clear();
      _playitems.addAll(
        await LibraryHelper.getMediaFromPaths(
          AppStorage().settings.videoPaths,
        ),
      );
      setState(() {
        _loaded = true;
      });
    };
  }

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.08),
      colorScheme.surface,
    );
    return [
      IconButton(
        tooltip: '切换显示样式'.l10n,
        hoverColor: backgroundColor,
        onPressed: () async {
          setState(() {
            _videoview = !_videoview;
          });
        },
        icon: Icon(
          _videoview ? Icons.movie_outlined : Icons.music_note,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      IconButton(
        tooltip: '切换显示视图'.l10n,
        hoverColor: backgroundColor,
        onPressed: () async {
          setState(() {
            _gridview = !_gridview;
          });
        },
        icon: Icon(
          _gridview ? Icons.calendar_view_month : Icons.view_agenda_outlined,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      const SizedBox(width: 10),
    ];
  }

  Widget _buildLibraryview(BuildContext context) {
    if (!_loaded) return const MLoadingPlaceHolder();
    if (_playitems.isEmpty) return const MEmptyHolder().toSliver();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _gridview ? _buildGridview(context) : _buildListview(context),
    );
  }

  Widget _buildGridview(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / (_videoview ? 180 : 160)).round(), 2);
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 6,
        crossAxisCount: cols,
        childAspectRatio: _videoview ? 8 / 7 : 5 / 6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = _playitems[index];
          return MInteractiveWrapper(
            menuController: MenuController(),
            menuChildren: _buildMediaMenuItems(
              context,
              colorScheme,
              info,
            ),
            onTap: () async {
              await AppStorage().closeMedia().then((value) {
                AppStorage().openMedia(info);
              });
              if (_videoview) {
                // if (!context.mounted) return;
                // pushRootPage(
                //   context,
                //   const PlayerPage(),
                // );
                // AppStorage().updateStatus();
                HomePage.switchView?.call();
              }
            },
            borderRadius: 20,
            child: MCoverCard(
              aspectRatio: _videoview ? 16 / 9 : 1,
              icon: _videoview ? Icons.movie_outlined : Icons.music_note,
              cover: info.cover,
              title: info.title,
            ),
          );
        },
        childCount: _playitems.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = _playitems[index];
          return MCoverListTile(
            aspectRatio: _videoview ? 4 / 3 : 1,
            height: 60,
            cover: info.cover,
            icon: _videoview ? Icons.movie_outlined : Icons.music_note,
            label: info.title,
            onTap: () async {
              await AppStorage().closeMedia().then((_) {
                AppStorage().openMedia(info);
                if (_videoview) {
                  // if (!context.mounted) return;
                  // pushRootPage(
                  //   context,
                  //   const PlayerPage(),
                  // );
                  HomePage.switchView?.call();
                }
              });
              AppStorage().updateStatus();
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  AppStorage().closeMedia();
                  AppStorage().openMedia(info);
                  if (_videoview) {
                    // if (!context.mounted) return;
                    // pushRootPage(
                    //   context,
                    //   const PlayerPage(),
                    // );
                    HomePage.switchView?.call();
                  }
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MenuButton(
                menuChildren: _buildMediaMenuItems(
                  context,
                  colorScheme,
                  info,
                ),
              ),
            ],
          );
        },
        childCount: _playitems.length,
      ),
    );
  }

  List<Widget> _buildMediaMenuItems(
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
            var savePath = item.cover!;
            var originalFile = File(coverPath);
            var newFile = File(savePath);
            item.cover = savePath;
            await originalFile.copy(newFile.path).then((_) {
              // final ImageProvider imageProvider = FileImage(newFile);
              // imageProvider.evict();
              setState(() {});
            });
          }
        },
      ),
      MMenuItem(
        icon: Icons.cleaning_services,
        label: '清除封面'.l10n,
        onPressed: () async {
          if (item.cover == null) return;
          var file = File(item.cover!);
          if (await file.exists()) {
            file.delete();
            final ImageProvider imageProvider = FileImage(file);
            imageProvider.evict();
          }
          setState(() {});
        },
      ),
      MMenuItem(
        icon: Icons.hide_source,
        label: '隐藏'.l10n,
        onPressed: null,
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
}
