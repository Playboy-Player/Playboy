import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';
import 'package:playboy/pages/playlist/playlist_menu.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/library_header.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/loading_holder.dart';
import 'package:playboy/widgets/menu_button.dart';
import 'package:playboy/widgets/menu_item.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => PlaylistState();
}

class PlaylistState extends State<PlaylistPage> {
  final TextEditingController _editingController = TextEditingController();
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
            title: '播放列表'.l10n,
            actions: _buildLibraryActions(context),
          ),
          _buildLibraryview(context),
        ],
      ),
    );
  }

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.08),
      colorScheme.surface,
    );
    return [
      IconButton(
        tooltip: '新建播放列表'.l10n,
        hoverColor: backgroundColor,
        onPressed: () {
          _editingController.clear();
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // surfaceTintColor: Colors.transparent,
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
                    uuid: getCurrentTimeString(),
                    items: [],
                    title: value,
                    cover: null,
                  );
                  LibraryHelper.savePlaylist(pl);
                  setState(() {
                    AppStorage().playlists.add(pl);
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
                      uuid: getCurrentTimeString(),
                      items: [],
                      title: _editingController.text,
                      cover: null,
                    );
                    LibraryHelper.savePlaylist(pl);
                    setState(() {
                      AppStorage().playlists.add(pl);
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
    if (AppStorage().playlists.isEmpty) return const MEmptyHolder().toSliver();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _gridview ? _buildGridview(context) : _buildListview(context),
    );
  }

  Widget _buildGridview(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
          PlaylistItem info = AppStorage().playlists[index];
          return MInteractiveWrapper(
            menuController: MenuController(),
            menuChildren: _buildMenuItems(context, colorScheme, info),
            onTap: () async {
              pushPage(
                context,
                PlaylistDetail(info: info),
              );
            },
            borderRadius: 20,
            child: MCoverCard(
              aspectRatio: 1,
              icon: Icons.playlist_play_rounded,
              cover: info.cover,
              title: info.title,
            ),
          );
        },
        childCount: AppStorage().playlists.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlaylistItem info = AppStorage().playlists[index];
          return MCoverListTile(
            aspectRatio: 1,
            height: 60,
            cover: info.cover,
            icon: Icons.music_note,
            label: info.title,
            onTap: () async {
              pushPage(
                context,
                PlaylistDetail(info: info),
              );
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  AppStorage().openPlaylist(info, false);
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MenuButton(
                menuChildren: _buildMenuItems(context, colorScheme, info),
              ),
            ],
          );
        },
        childCount: AppStorage().playlists.length,
      ),
    );
  }

  void _loadLibrary() async {
    _gridview = !AppStorage().settings.playlistListview;
    AppStorage().playlists.clear();
    AppStorage().playlists.addAll(await LibraryHelper.loadPlaylists());
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

  List<Widget> _buildMenuItems(
    BuildContext context,
    ColorScheme colorScheme,
    PlaylistItem item,
  ) {
    return [
      const SizedBox(height: 10),
      ...buildCommonPlaylistMenuItems(
        context,
        colorScheme,
        item,
      ),
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
            var savePath =
                '${AppStorage().dataPath}/playlists/${item.uuid}.cover.jpg';
            var originalFile = File(coverPath);
            var newFile = File(savePath);
            item.cover = savePath;
            await originalFile.copy(newFile.path).then(
              (_) {
                final ImageProvider imageProvider = FileImage(newFile);
                imageProvider.evict();
                setState(() {});
              },
            );
          }
        },
      ),
      MMenuItem(
        icon: Icons.cleaning_services,
        label: '清除封面'.l10n,
        onPressed: () async {
          setState(() {
            item.cover = null;
          });
          var coverPath =
              '${AppStorage().dataPath}/playlists/${item.uuid}.cover.jpg';
          var cover = File(coverPath);
          if (await cover.exists()) {
            await cover.delete();
          }
        },
      ),
      MMenuItem(
        icon: Icons.drive_file_rename_outline,
        label: '重命名'.l10n,
        onPressed: () {
          _editingController.clear();
          _editingController.text = item.title;
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              surfaceTintColor: Colors.transparent,
              title: Text('重命名'.l10n),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '名称'.l10n,
                ),
                onSubmitted: (value) {
                  LibraryHelper.renamePlaylist(
                    item,
                    value,
                  );
                  setState(() {});
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
                    LibraryHelper.renamePlaylist(
                      item,
                      _editingController.text,
                    );
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('确定'.l10n),
                ),
              ],
            ),
          );
        },
      ),
      MMenuItem(
        icon: Icons.delete_outline,
        label: '删除'.l10n,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('操作确认'.l10n),
                content: Text('确定要删除播放列表吗?'.l10n),
                actions: [
                  TextButton(
                    child: Text('取消'.l10n),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('确定'.l10n),
                    onPressed: () {
                      LibraryHelper.deletePlaylist(
                        item,
                      );
                      // AppStorage().playlists.removeAt(index);
                      AppStorage().playlists.remove(item);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
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
