import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/widgets/video_card.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({super.key, required this.info});
  final PlaylistItem info;

  @override
  PlaylistDetailState createState() => PlaylistDetailState();
}

// TODO: playlist edit
class PlaylistDetailState extends State<PlaylistDetail> {
  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.info.title),
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 140,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: widget.info.cover == null
                          ? Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                child: Image.file(File(widget.info.cover!)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.info.title,
                          style: const TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      colorScheme.primaryContainer)),
                              onPressed: () {
                                AppStorage().closeMedia();
                                AppStorage().openPlaylist(widget.info);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('顺序播放'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      colorScheme.primaryContainer)),
                              onPressed: () {
                                AppStorage().closeMedia();
                                AppStorage().openPlaylistShuffle(widget.info);
                                setState(() {});
                              },
                              icon: const Icon(Icons.shuffle),
                              label: const Text('随机播放'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SizedBox(
                    height: 80,
                    child: VideoListCard(info: widget.info.items[index]),
                  );
                },
                childCount: widget.info.items.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
