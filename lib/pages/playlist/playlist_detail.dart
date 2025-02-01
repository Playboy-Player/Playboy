import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/widgets/cover.dart';
import 'package:playboy/widgets/video_card.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({super.key, required this.info});
  final PlaylistItem info;

  @override
  PlaylistDetailState createState() => PlaylistDetailState();
}

class PlaylistDetailState extends State<PlaylistDetail> {
  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // titleSpacing: 0,
        // title: const Text('所有列表'),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context, true);
        //     },
        //     icon: const Icon(Icons.delete_outline),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.more_vert),
        //   ),
        //   const SizedBox(
        //     width: 10,
        //   )
        // ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 110,
                    child: MCover(
                      aspectRatio: 1,
                      cover: widget.info.cover,
                      icon: Icons.playlist_play_rounded,
                      iconSize: 60,
                      borderRadius: 20,
                      colorScheme: colorScheme,
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
                          style: const TextStyle(fontSize: 26),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  colorScheme.primaryContainer,
                                ),
                              ),
                              onPressed: () {
                                AppStorage().closeMedia();
                                AppStorage().openPlaylist(widget.info, false);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: Text(context.l10n.play),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  colorScheme.primaryContainer,
                                ),
                              ),
                              onPressed: () {
                                AppStorage().closeMedia();
                                AppStorage().openPlaylist(widget.info, true);
                                setState(() {});
                              },
                              icon: const Icon(Icons.shuffle),
                              label: Text(context.l10n.shuffle),
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
          const SliverToBoxAdapter(
            child: Divider(
              indent: 16,
              endIndent: 16,
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
