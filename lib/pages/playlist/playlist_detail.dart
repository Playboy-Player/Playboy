import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/pages/library/common_media_menu.dart';
import 'package:playboy/widgets/cover.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/menu/menu_button.dart';
import 'package:playboy/widgets/menu/menu_item.dart';

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
                          App().closeMedia();
                          App().openPlaylist(widget.info, false);
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: Text('播放'.l10n),
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
                          App().closeMedia();
                          App().openPlaylist(widget.info, true);
                          setState(() {});
                        },
                        icon: const Icon(Icons.shuffle),
                        label: Text('随机播放'.l10n),
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
              await App().closeMedia().then((_) {
                App().openMedia(info);
              });
              App().updateStatus();
            },
            actions: [
              MenuButton(
                menuChildren: _buildMediaMenuItems(
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

  List<Widget> _buildMediaMenuItems(
    BuildContext context,
    ColorScheme colorScheme,
    PlayItem item,
  ) {
    return [
      const SizedBox(height: 10),
      ...buildCommonMediaMenuItems(context, colorScheme, item),
      const Divider(),
      MMenuItem(
        icon: Icons.design_services_outlined,
        label: '修改封面'.l10n,
        onPressed: () async {
          String? coverPath =
              await FilePicker.platform.pickFiles(type: FileType.image).then(
            (result) {
              return result?.files.single.path;
            },
          );
          if (coverPath != null) {
            var savePath = item.cover;
            var originalFile = File(coverPath);
            var newFile = File(savePath);
            // item.cover = savePath;
            await originalFile.copy(newFile.path).then((_) {
              final ImageProvider imageProvider = FileImage(newFile);
              imageProvider.evict();
              setState(() {});
            });
          }
        },
      ),
      MMenuItem(
        icon: Icons.cleaning_services,
        label: '清除封面'.l10n,
        onPressed: () async {
          var file = File(item.cover);
          if (await file.exists()) {
            file.delete();
            final ImageProvider imageProvider = FileImage(file);
            await imageProvider.evict();
          }
          setState(() {});
        },
      ),
      MMenuItem(
        icon: Icons.delete_outline,
        label: '从播放列表移除'.l10n,
        onPressed: () {
          LibraryHelper.removeItemFromPlaylist(widget.info, item);
          setState(() {});
        },
      ),
      const Divider(),
      MMenuItem(
        icon: Icons.info_outline,
        label: '属性'.l10n,
        onPressed: null,
      ),
      const SizedBox(height: 10),
    ];
  }
}
