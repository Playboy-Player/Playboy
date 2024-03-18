import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';

class PlaylistPickerItem extends StatelessWidget {
  const PlaylistPickerItem({super.key, required this.info});
  final PlaylistItem info;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(6),
            child: AspectRatio(
              aspectRatio: 10 / 9,
              child: info.cover == null
                  ? Container(
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
                    ),
            )),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Text(
          info.title,
          style: const TextStyle(fontSize: 18),
        )),
      ],
    );
  }
}
