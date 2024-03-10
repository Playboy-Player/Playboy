import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/pages/media/m_player.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.info});
  final PlayItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Card(
      // surfaceTintColor: Colors.transparent,
      elevation: 1.6,
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
              flex: 2,
              child: info.cover == null
                  ? Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: colorScheme.tertiaryContainer,
                      ),
                      child: Icon(
                        Icons.movie_filter_rounded,
                        color: colorScheme.onTertiaryContainer,
                        size: 80,
                      ),
                    )
                  : Ink(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: colorScheme.tertiaryContainer,
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
              child: Center(
                  child: Text(
                info.title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )),
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
                          color: colorScheme.tertiaryContainer,
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: colorScheme.onTertiaryContainer,
                          size: 80,
                        ),
                      )
                    : Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.tertiaryContainer,
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
              onPressed: () {
                // LibraryHelper.addItemToFirstList(info);
              },
              icon: const Icon(Icons.add),
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
