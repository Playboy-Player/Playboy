import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/widgets/menu.dart';
import 'package:playboy/widgets/playlist_picker.dart';

class MusicCard extends StatelessWidget {
  const MusicCard({super.key, required this.info});

  final PlayItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    MenuController menuController = MenuController();
    return GestureDetector(
      onSecondaryTapDown: (details) {
        menuController.open(position: details.localPosition);
      },
      child: MenuAnchor(
        controller: menuController,
        style: MenuStyle(
          // surfaceTintColor:
          //     const WidgetStatePropertyAll(
          //         Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        menuChildren: _buildMenuItems(
          context,
          colorScheme,
          info,
        ),
        child: Column(
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
                    await AppStorage().closeMedia().then((value) {
                      AppStorage().openMedia(info);
                    });
                    AppStorage().updateStatus();
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: info.cover == null || !File(info.cover!).existsSync()
                      ? Ink(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colorScheme.secondaryContainer,
                          ),
                          child: Icon(
                            Icons.music_note,
                            color: colorScheme.secondary,
                            size: 50,
                          ),
                        )
                      : Ink(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: colorScheme.secondaryContainer,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(info.cover!),
                              ),
                            ),
                          ),
                          // child: Icon(
                          //   Icons.playlist_play_rounded,
                          //   color: colorScheme.onTertiaryContainer,
                          //   size: 80,
                          // ),
                        ),
                ),
              ),
            ),
            Expanded(
              child: Tooltip(
                message: info.title,
                waitDuration: const Duration(seconds: 2),
                child: Text(
                  info.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MusicListCard extends StatelessWidget {
  const MusicListCard({super.key, required this.info});

  final PlayItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await AppStorage().closeMedia().then((value) {
          AppStorage().openMedia(info);
        });
        AppStorage().updateStatus();
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(6),
              child: AspectRatio(
                aspectRatio: 1,
                child: info.cover == null || !File(info.cover!).existsSync()
                    ? Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: colorScheme.secondary,
                          size: 30,
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
                              File(info.cover!),
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
              info.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: '播放',
              onPressed: () {
                AppStorage().closeMedia();
                AppStorage().openMedia(info);
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
                  tooltip: '菜单',
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
              menuChildren: _buildMenuItems(context, colorScheme, info),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildMenuItems(
    BuildContext context, ColorScheme colorScheme, PlayItem item) {
  return [
    const SizedBox(height: 10),
    buildMenuItem(
      Icons.play_circle_outline_rounded,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('播放'),
      ),
      () {
        AppStorage().closeMedia();
        AppStorage().openMedia(item);
      },
    ),
    buildMenuItem(
      Icons.last_page,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('最后播放'),
      ),
      () {},
    ),
    buildMenuItem(
      Icons.add_circle_outline,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('添加到播放列表'),
      ),
      () {
        showDialog(
          barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
          useRootNavigator: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: const Text('添加到播放列表'),
            content: SizedBox(
              width: 300,
              height: 300,
              child: ListView.builder(
                itemBuilder: (context, indexList) {
                  return SizedBox(
                    height: 60,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        LibraryHelper.addItemToPlaylist(
                          AppStorage().playlists[indexList],
                          item,
                        );
                        Navigator.pop(context);
                      },
                      child: PlaylistPickerItem(
                          info: AppStorage().playlists[indexList]),
                    ),
                  );
                },
                itemCount: AppStorage().playlists.length,
              ),
            ),
          ),
        );
      },
    ),
    const Divider(),
    buildMenuItem(
      Icons.design_services_outlined,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('修改封面'),
      ),
      null,
    ),
    buildMenuItem(
      Icons.info_outline,
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('属性'),
      ),
      null,
    ),
    const SizedBox(height: 10),
  ];
}
