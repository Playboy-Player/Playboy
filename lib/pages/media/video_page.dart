import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/pages/media/media_menu.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/library_header.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/loading.dart';
import 'package:playboy/widgets/menu_button.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final List<PlayItem> _playitems = [];
  bool _loaded = false;
  bool _gridview = true;

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
            title: context.l10n.video,
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
      _playitems.addAll(await LibraryHelper.getMediaFromPaths(
          AppStorage().settings.videoPaths));
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
        tooltip: '切换显示视图',
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
    if (_playitems.isEmpty) return const MEmptyHolder();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _gridview ? _buildGridview(context) : _buildListview(context),
    );
  }

  Widget _buildGridview(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 180).round(), 2);
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 6,
        crossAxisCount: cols,
        childAspectRatio: 8 / 7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = _playitems[index];
          return MInteractiveWrapper(
            menuController: MenuController(),
            menuChildren: buildMediaMenuItems(
              context,
              colorScheme,
              info,
            ),
            onTap: () async {
              await AppStorage().closeMedia().then((value) {
                AppStorage().openMedia(info);
              });

              if (!context.mounted) return;
              pushRootPage(
                context,
                const MPlayer(),
              );
              AppStorage().updateStatus();
            },
            borderRadius: 20,
            child: MCoverCard(
              aspectRatio: 16 / 9,
              icon: Icons.movie_filter_rounded,
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
            aspectRatio: 4 / 3,
            height: 60,
            cover: info.cover,
            icon: Icons.movie_filter_rounded,
            label: info.title,
            onTap: () async {
              await AppStorage().closeMedia().then((_) {
                AppStorage().openMedia(info);

                if (!context.mounted) return;
                pushRootPage(
                  context,
                  const MPlayer(),
                );
              });
              AppStorage().updateStatus();
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  AppStorage().closeMedia();
                  AppStorage().openMedia(info);

                  if (!context.mounted) return;
                  pushRootPage(
                    context,
                    const MPlayer(),
                  );
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MMenuButton(
                menuChildren: buildMediaMenuItems(
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
}
