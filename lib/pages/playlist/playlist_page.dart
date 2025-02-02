import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/backend/utils/time_format.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/library_header.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/loading.dart';
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
            title: context.l10n.playlist,
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
        tooltip: context.l10n.newPlaylist,
        hoverColor: backgroundColor,
        onPressed: () {
          _editingController.clear();
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // surfaceTintColor: Colors.transparent,
              title: Text(context.l10n.newPlaylist),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.l10n.name,
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
                  child: Text(context.l10n.cancel),
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
                  child: Text(context.l10n.ok),
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
    if (AppStorage().playlists.isEmpty) return const MEmptyHolder();

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
            menuChildren: _buildMenuItems(context, colorScheme, index),
            onTap: () async {
              pushPage(
                context,
                PlaylistDetail(info: AppStorage().playlists[index]),
              );
            },
            borderRadius: 20,
            child: MCoverCard(
              aspectRatio: 1,
              icon: Icons.music_note,
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
                PlaylistDetail(info: AppStorage().playlists[index]),
              );
            },
            actions: [
              IconButton(
                tooltip: '播放',
                onPressed: () {
                  AppStorage()
                      .openPlaylist(AppStorage().playlists[index], false);
                },
                icon: const Icon(Icons.play_arrow),
              ),
              MMenuButton(
                menuChildren: _buildMenuItems(context, colorScheme, index),
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
    int index,
  ) {
    return [
      const SizedBox(height: 10),
      MMenuItem(
        icon: Icons.play_circle_outline_rounded,
        label: context.l10n.play,
        onPressed: () {
          AppStorage().closeMedia();
          AppStorage().openPlaylist(AppStorage().playlists[index], false);
        },
      ),
      MMenuItem(
        icon: Icons.shuffle,
        label: context.l10n.shuffle,
        onPressed: () {
          AppStorage().closeMedia();
          AppStorage().openPlaylist(
            AppStorage().playlists[index],
            true,
          );
        },
      ),
      MMenuItem(
        icon: Icons.add_circle_outline,
        label: context.l10n.addToPlaylist,
        onPressed: null,
        // () {
        //   AppStorage().appendPlaylist(
        //     AppStorage().playlists[index],
        //   );
        // },
      ),
      const Divider(),
      MMenuItem(
        icon: Icons.share,
        label: context.l10n.export,
        onPressed: () async {
          final originalFile = File(
            '${AppStorage().dataPath}/playlists/${AppStorage().playlists[index].uuid}.json',
          );
          String? newFilePath = await FilePicker.platform.saveFile(
            dialogTitle: context.l10n.saveAs,
            fileName: '${AppStorage().playlists[index].uuid}.json',
          );

          if (newFilePath != null) {
            final newFile = File(newFilePath);

            await originalFile.copy(newFile.path);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${context.l10n.fileSavedAs}: $newFilePath',
                ),
              ),
            );
          }
        },
      ),
      MMenuItem(
        icon: Icons.design_services_outlined,
        label: context.l10n.changeCover,
        onPressed: () async {
          String? coverPath =
              await FilePicker.platform.pickFiles(type: FileType.image).then(
            (result) {
              return result?.files.single.path;
            },
          );
          if (coverPath != null) {
            var savePath =
                '${AppStorage().dataPath}/playlists/${AppStorage().playlists[index].uuid}.cover.jpg';
            var originalFile = File(coverPath);
            var newFile = File(
              savePath,
            );
            AppStorage().playlists[index].cover = savePath;
            await originalFile.copy(newFile.path).then(
              (value) {
                setState(() {});
              },
            );
          }
        },
      ),
      MMenuItem(
        icon: Icons.cleaning_services,
        label: context.l10n.removeCover,
        onPressed: () async {
          setState(() {
            AppStorage().playlists[index].cover = null;
          });
          var coverPath =
              '${AppStorage().dataPath}/playlists/${AppStorage().playlists[index].uuid}.cover.jpg';
          var cover = File(coverPath);
          if (await cover.exists()) {
            await cover.delete();
          }
        },
      ),
      MMenuItem(
        icon: Icons.drive_file_rename_outline,
        label: context.l10n.rename,
        onPressed: () {
          _editingController.clear();
          _editingController.text = AppStorage().playlists[index].title;
          showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              surfaceTintColor: Colors.transparent,
              title: Text(context.l10n.rename),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.l10n.name,
                ),
                onSubmitted: (value) {
                  LibraryHelper.renamePlaylist(
                    AppStorage().playlists[index],
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
                  child: Text(context.l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    LibraryHelper.renamePlaylist(
                      AppStorage().playlists[index],
                      _editingController.text,
                    );
                    setState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(context.l10n.ok),
                ),
              ],
            ),
          );
        },
      ),
      MMenuItem(
        icon: Icons.delete_outline,
        label: context.l10n.delete,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(context.l10n.confirm),
                content: Text(context.l10n.confirmDeletePlaylist),
                actions: [
                  TextButton(
                    child: Text(context.l10n.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(context.l10n.ok),
                    onPressed: () {
                      LibraryHelper.deletePlaylist(
                        AppStorage().playlists[index],
                      );
                      AppStorage().playlists.removeAt(index);
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
      const SizedBox(height: 10),
    ];
  }
}
