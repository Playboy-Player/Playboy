import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';

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
    _init();
  }

  void _init() async {
    _gridview = !AppStorage().settings.playlistListview;
    AppStorage().playlists.clear();
    AppStorage().playlists.addAll(await LibraryHelper.loadPlaylists());
    if (!mounted) return;
    setState(() {
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 180).round(), 2);
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
                context.l10n.playlist,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              // background:
            ),
            pinned: true,
            expandedHeight: 80,
            collapsedHeight: 60,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: FloatingActionButton(
                  tooltip: Intl.message('新建播放列表',
                      name: 'createPlaylist'), //'新建播放列表',
                  heroTag: 'new_list',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {
                    _editingController.clear();
                    showDialog(
                      barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                      useRootNavigator: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        title: Text(context.l10n.create_playlist),
                        content: TextField(
                          autofocus: true,
                          maxLines: 1,
                          controller: _editingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                Intl.message('名称', name: 'labelName'), //'名称',
                          ),
                          onSubmitted: (value) {
                            var pl = PlaylistItem(
                              uuid: idGenerator(),
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
                                uuid: idGenerator(),
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
                            child: Text(context.l10n.confirm),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.add_circle_outline),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: FloatingActionButton(
                  heroTag: 'view_list',
                  tooltip: Intl.message('切换显示视图', name: "Toggle Display View"),
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {
                    setState(() {
                      _gridview = !_gridview;
                    });
                  },
                  child: Icon(_gridview
                      ? Icons.calendar_view_month
                      : Icons.view_agenda_outlined),
                ),
              ),
            ],
          ),
          _loaded
              ? (AppStorage().playlists.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upcoming_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    context.l10n.no_playlists,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: _gridview
                          ? SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 6,
                                crossAxisCount: cols,
                                childAspectRatio: 12 / 11,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  MenuController menuController =
                                      MenuController();
                                  return GestureDetector(
                                    onSecondaryTapDown: (details) {
                                      menuController.open(
                                        position: details.localPosition,
                                      );
                                    },
                                    onLongPress: () {
                                      menuController.open();
                                    },
                                    child: MenuAnchor(
                                      controller: menuController,
                                      style: MenuStyle(
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        // backgroundColor: WidgetStatePropertyAll(
                                        //   colorScheme.tertiaryContainer,
                                        // ),
                                      ),
                                      menuChildren: _buildMenuItems(
                                          context, colorScheme, index),
                                      child: buildPlaylistCard(
                                        index,
                                        colorScheme,
                                      ),
                                    ),
                                  );
                                },
                                childCount: AppStorage().playlists.length,
                              ),
                            )
                          : SliverList.builder(
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: 80,
                                  child: buildPlaylistListCard(
                                    index,
                                    colorScheme,
                                  ),
                                );
                              },
                              itemCount: AppStorage().playlists.length,
                            ),
                    ))
              : const SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }

  Widget buildPlaylistCard(int index, ColorScheme colorScheme) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: InkWell(
              onTap: () async {
                final delete = await Navigator.push(
                  context,
                  // MaterialPageRoute(
                  //     builder: (context) =>
                  //         PlaylistDetail(info: AppStorage().playlists[index])),
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        PlaylistDetail(info: AppStorage().playlists[index]),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                if (delete != null && delete == true) {
                  LibraryHelper.deletePlaylist(AppStorage().playlists[index]);
                  AppStorage().playlists.removeAt(index);
                  setState(() {});
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: AppStorage().playlists[index].cover == null
                  ? Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorScheme.secondaryContainer,
                      ),
                      child: Icon(
                        Icons.playlist_play_rounded,
                        color: colorScheme.secondary,
                        size: 60,
                      ),
                    )
                  : Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colorScheme.secondaryContainer,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            File(AppStorage().playlists[index].cover!)
                                .readAsBytesSync(),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
        Expanded(
          child: Tooltip(
            message: AppStorage().playlists[index].title,
            waitDuration: const Duration(seconds: 2),
            child: Text(
              AppStorage().playlists[index].title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPlaylistListCard(int index, ColorScheme colorScheme) {
    return InkWell(
      // overlayColor: WidgetStatePropertyAll(Colors.transparent),
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        final delete = await Navigator.push(
          context,
          // MaterialPageRoute(
          //     builder: (context) =>
          //         PlaylistDetail(info: AppStorage().playlists[index])),
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                PlaylistDetail(info: AppStorage().playlists[index]),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        if (delete != null && delete == true) {
          LibraryHelper.deletePlaylist(AppStorage().playlists[index]);
          AppStorage().playlists.removeAt(index);
          setState(() {});
        }
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(6),
              child: AspectRatio(
                aspectRatio: 10 / 9,
                child: AppStorage().playlists[index].cover == null
                    ? Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: Icon(
                          Icons.playlist_play_rounded,
                          color: colorScheme.secondary,
                          size: 40,
                        ),
                      )
                    : Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.secondaryContainer,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              File(AppStorage().playlists[index].cover!),
                            ),
                          ),
                        ),
                        // child: Icon(
                        //   Icons.playlist_play_rounded,
                        //   color: colorScheme.onTertiaryContainer,
                        //   size: 80,
                        // ),
                      ),
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            AppStorage().playlists[index].title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: Intl.message('播放', name: "Play"),
              onPressed: () {
                AppStorage().openPlaylist(AppStorage().playlists[index], false);
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: MenuAnchor(
              style: MenuStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // backgroundColor: WidgetStatePropertyAll(
                //   colorScheme.tertiaryContainer,
                // ),
              ),
              builder: (_, controller, child) {
                return IconButton(
                  tooltip: Intl.message('菜单', name: "Menu"),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  icon: const Icon(Icons.more_vert),
                );
              },
              menuChildren: _buildMenuItems(context, colorScheme, index),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, Widget label, Function()? onPressed) {
    return MenuItemButton(
      leadingIcon: Icon(
        icon,
        size: 18,
      ),
      onPressed: onPressed,
      child: label,
    );
  }

  List<Widget> _buildMenuItems(
      BuildContext context, ColorScheme colorScheme, int index) {
    return [
      const SizedBox(height: 10),
      _buildMenuItem(
        Icons.play_circle_outline_rounded,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.play_in_order),
        ),
        () {
          AppStorage().closeMedia();
          AppStorage().openPlaylist(AppStorage().playlists[index], false);
        },
      ),
      _buildMenuItem(
        Icons.shuffle,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.play_randomly),
        ),
        () {
          AppStorage().closeMedia();
          AppStorage().openPlaylist(
            AppStorage().playlists[index],
            true,
          );
        },
      ),
      _buildMenuItem(
        Icons.add_circle_outline,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.append_to_current_list),
        ),
        () {
          AppStorage().appendPlaylist(
            AppStorage().playlists[index],
          );
        },
      ),
      const Divider(),
      _buildMenuItem(
        Icons.share,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.export),
        ),
        () async {
          final originalFile = File(
            '${AppStorage().dataPath}/playlists/${AppStorage().playlists[index].uuid}.json',
          );
          String? newFilePath = await FilePicker.platform.saveFile(
            dialogTitle: context.l10n.save_as,
            fileName: '${AppStorage().playlists[index].uuid}.json',
          );

          if (newFilePath != null) {
            final newFile = File(newFilePath);

            await originalFile.copy(newFile.path);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${context.l10n.file_saved_as} $newFilePath',
                ),
              ),
            );
          }
        },
      ),
      _buildMenuItem(
        Icons.design_services_outlined,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.modify_cover),
        ),
        () async {
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
      _buildMenuItem(
        Icons.cleaning_services,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            context.l10n.clear_cover,
          ),
        ),
        () async {
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
      _buildMenuItem(
        Icons.drive_file_rename_outline,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.rename),
        ),
        () {
          _editingController.clear();
          showDialog(
            barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              surfaceTintColor: Colors.transparent,
              title: Text(
                '${context.l10n.rename} ${AppStorage().playlists[index].title}',
              ),
              content: TextField(
                autofocus: true,
                maxLines: 1,
                controller: _editingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: Intl.message('名称', name: "Name"),
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
                  child: Text(context.l10n.confirm),
                ),
              ],
            ),
          );
        },
      ),
      _buildMenuItem(
        Icons.delete_outline,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text(context.l10n.delete),
        ),
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(context.l10n.confirm_action),
                content: Text(context.l10n.confirm_delete_playlist),
                actions: [
                  TextButton(
                    child: Text(context.l10n.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(context.l10n.confirm),
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

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}
