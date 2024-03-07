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
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => PlaylistDetail(info: info)));
          // AppStorage().openMedia(info);
          await AppStorage().closeMedia().then((value) {
            if (!context.mounted) return;
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => MPlayer(
                  info: info,
                  currentMedia: false,
                ),
              ),
            );
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
