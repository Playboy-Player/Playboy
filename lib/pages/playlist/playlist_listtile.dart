import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/menu/menu_button.dart';

class PlaylistListtile extends StatefulWidget {
  const PlaylistListtile({
    super.key,
    required this.info,
    required this.actions,
    required this.menuItems,
    this.onTap,
  });

  final PlaylistItem info;
  final Function()? onTap;
  final List<Widget> actions;
  final List<Widget> menuItems;

  @override
  State<PlaylistListtile> createState() => _PlaylistListtileState();
}

class _PlaylistListtileState extends State<PlaylistListtile> {
  @override
  Widget build(BuildContext context) {
    return MCoverListTile(
      aspectRatio: 1,
      height: 60,
      cover: widget.info.cover,
      icon: Icons.playlist_play_rounded,
      label: widget.info.title,
      onTap: widget.onTap,
      actions: [
        ...widget.actions,
        MenuButton(
          menuChildren: widget.menuItems,
        ),
      ],
    );
  }
}
