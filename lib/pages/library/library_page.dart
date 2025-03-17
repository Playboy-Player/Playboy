import 'dart:math';

import 'package:flutter/material.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
import 'package:playboy/pages/library/library_loader.dart';
import 'package:playboy/pages/library/media_menu.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/library/library_header.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/loading_holder.dart';
import 'package:playboy/widgets/menu/menu_button.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _gridview = true;

  @override
  void initState() {
    super.initState();
    _gridview = !App().settings.videoLibListview;
    App().updateVideoPage = () async {
      setState(() {
        App().mediaLibraryLoaded = false;
      });
      App().mediaLibrary.clear();
      App().mediaLibrary.addAll(
            await LibraryHelper.getMediaFromPaths(
              App().settings.videoPaths,
            ),
          );
      setState(() {
        App().mediaLibraryLoaded = true;
      });
    };
    loadMediaLibrary(() {
      if (!mounted) return;
      setState(() {});
    });
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

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return [
      IconButton(
        tooltip: '排序'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () async {},
        icon: Icon(
          Icons.sort,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      IconButton(
        tooltip: '切换显示视图'.l10n,
        hoverColor: colorScheme.actionHoverColor,
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
      IconButton(
        tooltip: '搜索'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () async {},
        icon: Icon(
          Icons.search,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      const SizedBox(width: 10),
    ];
  }

  Widget _buildLibraryview(BuildContext context) {
    if (!App().mediaLibraryLoaded) return const MLoadingPlaceHolder();
    if (App().mediaLibrary.isEmpty) return const MEmptyHolder().toSliver();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _gridview ? _buildGridview(context) : _buildListview(context),
    );
  }

  Widget _buildGridview(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 200;
    final cols = max((width / 160).round(), 2);
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 6,
        crossAxisCount: cols,
        childAspectRatio: 8 / 7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = App().mediaLibrary[index];
          return MInteractiveWrapper(
            menuController: MenuController(),
            menuChildren: buildMediaMenuItems(
              () => setState(() {}),
              context,
              colorScheme,
              info,
            ),
            onTap: () async {
              await App().closeMedia().then((value) {
                App().openMedia(info);
              });
              App().actions['togglePlayer']?.call();
            },
            borderRadius: 20,
            child: MCoverCard(
              aspectRatio: 16 / 9,
              icon: Icons.movie_outlined,
              cover: info.cover,
              title: info.title,
            ),
          );
        },
        childCount: App().mediaLibrary.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = App().mediaLibrary[index];
          return MCoverListTile(
            aspectRatio: 4 / 3,
            height: 60,
            cover: info.cover,
            icon: Icons.movie_outlined,
            label: info.title,
            onTap: () async {
              await App().closeMedia().then((_) {
                App().openMedia(info);
                App().actions['togglePlayer']?.call();
              });
              App().updateStatus();
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  App().closeMedia();
                  App().openMedia(info);
                  App().actions['togglePlayer']?.call();
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MenuButton(
                menuChildren: buildMediaMenuItems(
                  () => setState(() {}),
                  context,
                  colorScheme,
                  info,
                ),
              ),
            ],
          );
        },
        childCount: App().mediaLibrary.length,
      ),
    );
  }
}
