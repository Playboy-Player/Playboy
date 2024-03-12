import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({super.key, required this.info});
  final PlaylistItem info;

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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlaylistDetail(info: info)));
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
                        Icons.playlist_play_rounded,
                        color: colorScheme.onTertiaryContainer,
                        size: 80,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(info.cover!)),
                      ),
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

class PlaylistListCard extends StatelessWidget {
  const PlaylistListCard({super.key, required this.info});
  final PlaylistItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaylistDetail(info: info)));
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(6),
              child: AspectRatio(
                aspectRatio: 10 / 9,
                child: info.cover == null
                    ? Ink(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme.tertiaryContainer,
                        ),
                        child: Icon(
                          Icons.playlist_play_rounded,
                          color: colorScheme.onTertiaryContainer,
                          size: 40,
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
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more),
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
