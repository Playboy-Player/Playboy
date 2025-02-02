import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/widgets/cover.dart';

class PlayerListCard extends StatelessWidget {
  const PlayerListCard({
    super.key,
    required this.info,
    required this.isPlaying,
  });
  final PlayItem info;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: MCover(
            icon: Icons.music_note,
            iconSize: 20,
            borderRadius: 10,
            cover: info.cover,
            aspectRatio: 1,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            info.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: isPlaying ? colorScheme.primary : null,
            ),
          ),
        ),
      ],
    );
  }
}
