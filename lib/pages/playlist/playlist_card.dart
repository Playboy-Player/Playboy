import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';

class PlaylistCard extends StatefulWidget {
  const PlaylistCard({
    super.key,
    required this.info,
    required this.menuItems,
    this.onTap,
  });

  final PlaylistItem info;
  final List<Widget> menuItems;
  final Function()? onTap;

  @override
  State<PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends State<PlaylistCard> {
  @override
  Widget build(BuildContext context) {
    return MInteractiveWrapper(
      menuController: MenuController(),
      menuChildren: widget.menuItems,
      onTap: widget.onTap,
      borderRadius: 20,
      child: MCoverCard(
        aspectRatio: 1,
        icon: Icons.playlist_play_rounded,
        cover: widget.info.cover,
        title: widget.info.title,
      ),
    );
  }
}
