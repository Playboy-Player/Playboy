import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playitem.dart';

class PlayerListCard extends StatelessWidget {
  const PlayerListCard(
      {super.key, required this.info, required this.isPlaying});
  final PlayItem info;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(6),
            child: AspectRatio(
              aspectRatio: 1,
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
                        size: 20,
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
                    ),
            )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          info.title,
          style: TextStyle(
            fontSize: 14,
            color: isPlaying ? colorScheme.primary : null,
          ),
        )),
      ],
    );
  }
}
