import 'dart:math';

import 'package:flutter/material.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/string_utils.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
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
  final TextEditingController _editingController = TextEditingController();
  bool _gridview = true;

  String _filter = '';
  List<PlayItem> _contents = App().mediaLibrary;

  @override
  void initState() {
    super.initState();
    _gridview = !App().settings.videoLibListview;
    App().actions['rescanLibrary'] = () async {
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
    if (!App().mediaLibraryLoaded) {
      App().executeAction('rescanLibrary');
    }
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
          if (_filter != '')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('${'正在展示以下内容的搜索结果: '.l10n}$_filter'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filter = '';
                            _contents = App().mediaLibrary;
                          });
                        },
                        child: Text('还原'.l10n),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ).toSliver(),
          _buildLibraryview(context),
        ],
      ),
    );
  }

  void _search(String target) {
    setState(() {
      _filter = target;
      _updateResult();
    });
  }

  void _updateResult() {
    _contents = App()
        .mediaLibrary
        .where(
          (e) => isSubsequence(_filter, e.title),
        )
        .toList();
  }

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return [
      IconButton(
        tooltip: '播放'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () {
          App().openPlaylist(
            PlaylistItem(title: 'all', items: _contents),
            false,
          );
        },
        icon: Icon(
          Icons.play_arrow_rounded,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      IconButton(
        tooltip: '随机播放'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () {
          App().openPlaylist(
            PlaylistItem(title: 'all', items: _contents),
            true,
          );
        },
        icon: Icon(
          Icons.shuffle_rounded,
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
        onPressed: () async {
          _editingController.clear();
          App().dialog(
            (BuildContext context) => AlertDialog(
              title: Text('搜索播放列表'.l10n),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '名称'.l10n,
                ),
                onSubmitted: (value) {
                  _search(value);
                  Navigator.pop(context);
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
                  onPressed: () {
                    _search(_editingController.text);
                    Navigator.pop(context);
                  },
                  child: Text('确定'.l10n),
                ),
              ],
            ),
          );
        },
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
    if (_contents.isEmpty) return const MEmptyHolder().toSliver();

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
          PlayItem info = _contents[index];
          return MInteractiveWrapper(
            menuController: MenuController(),
            menuChildren: buildMediaMenuItems(
              () => setState(() {
                _updateResult();
              }),
              context,
              colorScheme,
              info,
            ),
            onTap: () async {
              App().openMedia(info);
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
        childCount: _contents.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = _contents[index];
          return MCoverListTile(
            aspectRatio: 4 / 3,
            height: 60,
            cover: info.cover,
            icon: Icons.movie_outlined,
            label: info.title,
            onTap: () async {
              App().openMedia(info);
              App().actions['togglePlayer']?.call();
              App().updateStatus();
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  App().openMedia(info);
                  App().actions['togglePlayer']?.call();
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MenuButton(
                menuChildren: buildMediaMenuItems(
                  () => setState(() {
                    _updateResult();
                  }),
                  context,
                  colorScheme,
                  info,
                ),
              ),
            ],
          );
        },
        childCount: _contents.length,
      ),
    );
  }
}
