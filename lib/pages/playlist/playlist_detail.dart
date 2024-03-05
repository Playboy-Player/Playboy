import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/models/playlist_item.dart';

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
          title: Text(widget.info.title),
        ),
        body: ListView.builder(
          // children: [
          // Padding(
          //   padding: const EdgeInsets.all(24),
          //   child: Row(
          //     // mainAxisAlignment: MainAxisAlignment.center,
          //     // crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       SizedBox(
          //         width: 140,
          //         child: AspectRatio(
          //           aspectRatio: 1,
          //           child: widget.pl.cover == null
          //               ? Container(
          //                   width: double.infinity,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(20),
          //                     color: colorScheme.tertiaryContainer,
          //                   ),
          //                   child: Icon(
          //                     Icons.playlist_play_rounded,
          //                     color: colorScheme.onTertiaryContainer,
          //                     size: 80,
          //                   ),
          //                 )
          //               : SizedBox(
          //                   width: double.infinity,
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(20),
          //                     child: Image.file(File(widget.pl.cover!)),
          //                   ),
          //                 ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 20,
          //       ),
          //       Expanded(
          //         child: Text(
          //           widget.pl.title,
          //           style: const TextStyle(
          //               fontSize: 26, fontWeight: FontWeight.w500),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // ],
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
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
                      child: Text(
                        widget.info.title,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              );
            }
            return null;
          },
        ));
  }
}
