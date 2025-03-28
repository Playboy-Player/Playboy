import 'dart:math';

import 'package:flutter/material.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/string_utils.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
import 'package:playboy/pages/playlist/playlist_card.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';
import 'package:playboy/pages/playlist/playlist_listtile.dart';
import 'package:playboy/pages/playlist/playlist_loader.dart';
import 'package:playboy/pages/playlist/playlist_menu.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/library/library_header.dart';
import 'package:playboy/widgets/loading_holder.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final TextEditingController _editingController = TextEditingController();
  bool _gridview = true;

  String _filter = '';
  List<PlaylistItem> _contents = [];

  @override
  void initState() {
    super.initState();
    _gridview = !App().settings.playlistListview;
    loadPlaylists(() {
      if (!mounted) return;
      setState(() {
        _contents = App().playlists;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MLibraryHeader(
            title: '播放列表'.l10n,
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
                            _contents = App().playlists;
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
        .playlists
        .where(
          (e) => isSubsequence(_filter, e.title),
        )
        .toList();
  }

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return [
      IconButton(
        tooltip: '新建播放列表'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () {
          _editingController.clear();
          App().dialog(
            (BuildContext context) => AlertDialog(
              title: Text('新建播放列表'.l10n),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '名称'.l10n,
                ),
                onSubmitted: (value) {
                  var pl = PlaylistItem(
                    items: [],
                    title: value,
                  );
                  LibraryHelper.savePlaylist(pl);
                  setState(() {
                    App().playlists.add(pl);
                    _updateResult();
                  });
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
                    var pl = PlaylistItem(
                      items: [],
                      title: _editingController.text,
                    );
                    LibraryHelper.savePlaylist(pl);
                    setState(() {
                      App().playlists.add(pl);
                      _updateResult();
                    });
                    Navigator.pop(context);
                  },
                  child: Text('确定'.l10n),
                ),
              ],
            ),
          );
        },
        icon: Icon(
          Icons.add_circle_outline,
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
    if (!App().playlistLoaded) return const MLoadingPlaceHolder();
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
        childAspectRatio: 5 / 6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlaylistItem info = _contents[index];
          return PlaylistCard(
            info: info,
            menuItems: buildPlaylistMenuItems(
              () => setState(() {
                _updateResult();
              }),
              context,
              colorScheme,
              info,
            ),
            onTap: () async {
              pushPage(
                context,
                PlaylistDetail(info: info),
              );
            },
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
          PlaylistItem info = _contents[index];
          return PlaylistListtile(
            onTap: () async {
              pushPage(
                context,
                PlaylistDetail(info: info),
              );
            },
            info: info,
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  App().openPlaylist(info, false);
                },
                icon: const Icon(Icons.play_arrow),
              )
            ],
            menuItems: buildPlaylistMenuItems(
              () => setState(() {
                _updateResult();
              }),
              context,
              colorScheme,
              info,
            ),
          );
        },
        childCount: _contents.length,
      ),
    );
  }
}
