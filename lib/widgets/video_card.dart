import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/widgets/playlist_picker.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.info});
  final PlayItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () async {
          await AppStorage().closeMedia().then((value) {
            if (!context.mounted) return;
            AppStorage().openMedia(info);
            Navigator.of(context, rootNavigator: true)
                .push(
              MaterialPageRoute(
                builder: (context) => const MPlayer(),
              ),
            )
                .then((value) {
              AppStorage().updateStatus();
            });
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: info.cover == null
                  ? Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: colorScheme.secondaryContainer,
                      ),
                      child: Icon(
                        Icons.movie_filter_rounded,
                        color: colorScheme.secondary,
                        size: 50,
                      ),
                    )
                  : Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
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
            Expanded(
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: colorScheme.secondaryContainer.withOpacity(0.6),
                ),
                child: Center(
                    child: Text(
                  info.title,
                  style: TextStyle(
                    color: colorScheme.onSecondaryContainer,
                    fontSize: 16,
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VideoListCard extends StatelessWidget {
  const VideoListCard({super.key, required this.info});
  final PlayItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await AppStorage().closeMedia().then((value) {
          if (!context.mounted) return;
          AppStorage().openMedia(info);
          Navigator.of(context, rootNavigator: true)
              .push(
            MaterialPageRoute(
              builder: (context) => const MPlayer(),
            ),
          )
              .then((value) {
            AppStorage().updateStatus();
          });
        });
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(6),
              child: AspectRatio(
                aspectRatio: 14 / 9,
                child: info.cover == null
                    ? Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: Icon(
                          Icons.movie_filter,
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
          )),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filledTonal(
              tooltip: '播放',
              onPressed: () async {
                await AppStorage().closeMedia().then((value) {
                  if (!context.mounted) return;
                  AppStorage().openMedia(info);

                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => const MPlayer(),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.play_arrow),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filledTonal(
              tooltip: '添加到播放列表',
              onPressed: () {
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
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 60,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                LibraryHelper.addItemToPlaylist(
                                    AppStorage().playlists[index], info);
                                Navigator.pop(context);
                              },
                              child: PlaylistPickerItem(
                                  info: AppStorage().playlists[index]),
                            ),
                          );
                        },
                        itemCount: AppStorage().playlists.length,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            width: 6,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: '更多',
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
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
