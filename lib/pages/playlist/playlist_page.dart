import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';
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
        colorScheme.primary.withValues(alpha: 0.08), colorScheme.surface);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
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
                  tooltip: context.l10n.newPlaylist,
                  heroTag: 'new_list',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
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
                            child: Text(context.l10n.ok),
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
                  tooltip: context.l10n.toggleDisplayMode,
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
                          shape: const RoundedRectangleBorder(
                            // side: BorderSide(
                            //   color: Theme.of(context).colorScheme.outline,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: SizedBox(
                            height: 200,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.upcoming_rounded,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    context.l10n.noPlaylists,
                                    style: const TextStyle(fontSize: 20),
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
                                  height: 60,
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
        Navigator.push(
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
                          borderRadius: BorderRadius.circular(12),
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
                          borderRadius: BorderRadius.circular(12),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              AppStorage().playlists[index].title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: context.l10n.play,
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
                  tooltip: context.l10n.menu,
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

  // Widget _buildMenuItem(IconData icon, Widget label, Function()? onPressed) {
  //   return MenuItemButton(
  //     leadingIcon: Icon(
  //       icon,
  //       size: 18,
  //     ),
  //     onPressed: onPressed,
  //     child: label,
  //   );
  // }

  List<Widget> _buildMenuItems(
      BuildContext context, ColorScheme colorScheme, int index) {
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

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}
