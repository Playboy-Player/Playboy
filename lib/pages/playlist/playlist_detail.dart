import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/l10n.dart';
import 'package:playboy/pages/media/media_menu.dart';
import 'package:playboy/widgets/cover.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/menu_button.dart';

class PlaylistDetail extends StatefulWidget {
  const PlaylistDetail({super.key, required this.info});
  final PlaylistItem info;

  @override
  PlaylistDetailState createState() => PlaylistDetailState();
}

class PlaylistDetailState extends State<PlaylistDetail> {
  @override
  Widget build(BuildContext context) {
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
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          const SliverToBoxAdapter(
            child: Divider(indent: 16, endIndent: 16),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: _buildListview(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverToBoxAdapter(
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
                            colorScheme.primaryContainer.withValues(
                              alpha: 0.6,
                            ),
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
                            colorScheme.primaryContainer.withValues(
                              alpha: 0.6,
                            ),
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
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          PlayItem info = widget.info.items[index];
          return MCoverListTile(
            aspectRatio: 1,
            height: 50,
            cover: info.cover,
            icon: Icons.music_note,
            label: info.title,
            onTap: () async {
              await AppStorage().closeMedia().then((_) {
                AppStorage().openMedia(info);
              });
              AppStorage().updateStatus();
            },
            actions: [
              MMenuButton(
                menuChildren: buildMediaMenuItems(
                  context,
                  colorScheme,
                  info,
                ),
              ),
            ],
          );
        },
        childCount: widget.info.items.length,
      ),
    );
  }
}
