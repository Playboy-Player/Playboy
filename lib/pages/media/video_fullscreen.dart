import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/storage.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FullscreenPlayPage extends StatefulWidget {
  const FullscreenPlayPage({super.key});

  @override
  FullscreenPlayer createState() => FullscreenPlayer();
}

// TODO: 隐藏鼠标
class FullscreenPlayer extends State<FullscreenPlayPage> {
  late final controller = AppStorage().controller;

  // bool loop = false;
  // bool shuffle = false;

  // bool seeking = false;
  // double seekingPos = 0;

  bool showControlBar = false;

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.08), colorScheme.surface);
    return Scaffold(
      body: Stack(
        children: [
          Video(
            controller: controller,
            controls: NoVideoControls,
            subtitleViewConfiguration:
                const SubtitleViewConfiguration(visible: false),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: showControlBar ? 0.9 : 0,
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    showControlBar = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    showControlBar = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  // width: 400,
                  height: 100,
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          StreamBuilder(
                              stream: AppStorage().playboy.stream.position,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                      '${snapshot.data!.inSeconds ~/ 3600}:${(snapshot.data!.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(snapshot.data!.inSeconds % 60).toString().padLeft(2, '0')}');
                                } else {
                                  return Text(
                                      '${AppStorage().position.inSeconds ~/ 3600}:${(AppStorage().position.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(AppStorage().position.inSeconds % 60).toString().padLeft(2, '0')}');
                                }
                              }),
                          Expanded(child: _buildSeekbarFullscreen()),
                          Text(
                              '${AppStorage().duration.inSeconds ~/ 3600}:${(AppStorage().duration.inSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(AppStorage().duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      _buildControlbarFullscreen(colorScheme),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // MouseRegion()
        ],
      ),
    );
  }

  Widget _buildSeekbarFullscreen() {
    return SliderTheme(
      data: SliderThemeData(
        // trackHeight: videoMode ? 8 : null,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: StreamBuilder(
        stream: AppStorage().playboy.stream.position,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          return Slider(
            max: AppStorage().duration.inMilliseconds.toDouble(),
            value: AppStorage().seeking
                ? AppStorage().seekingPos
                : min(
                    snapshot.hasData
                        ? snapshot.data!.inMilliseconds.toDouble()
                        : AppStorage().position.inMilliseconds.toDouble(),
                    AppStorage().duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              // player.seek(Duration(milliseconds: value.toInt()));
              setState(() {
                AppStorage().seekingPos = value;
              });
            },
            onChangeStart: (value) {
              setState(() {
                AppStorage().seeking = true;
              });
            },
            onChangeEnd: (value) {
              AppStorage()
                  .playboy
                  .seek(Duration(milliseconds: value.toInt()))
                  .then((value) => {
                        setState(() {
                          AppStorage().seeking = false;
                        })
                      });
            },
          );
        },
      ),
    );
  }

  Widget _buildControlbarFullscreen(ColorScheme colorScheme) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    AppStorage().playboy.setVolume(0);
                  });
                  AppStorage().settings.volume = 0;
                  AppStorage().saveSettings();
                },
                icon: Icon(AppStorage().playboy.state.volume == 0
                    ? Icons.volume_off
                    : Icons.volume_up)),
            SizedBox(
              width: 100,
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: colorScheme.secondaryContainer,
                  thumbColor: colorScheme.onSecondaryContainer,
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  max: 100,
                  value: AppStorage().playboy.state.volume,
                  onChanged: (value) {
                    setState(() {
                      AppStorage().playboy.setVolume(value);
                    });
                  },
                  onChangeEnd: (value) {
                    setState(() {});
                    AppStorage().settings.volume = value;
                    AppStorage().saveSettings();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      IconButton(
          onPressed: () {
            setState(() {
              AppStorage().shuffle = !AppStorage().shuffle;
            });
          },
          icon: AppStorage().shuffle
              ? const Icon(Icons.shuffle_on)
              : const Icon(Icons.shuffle)),
      const SizedBox(
        width: 10,
      ),
      IconButton(
          onPressed: () {
            if (AppStorage().playboy.state.playlistMode ==
                PlaylistMode.single) {
              AppStorage().playboy.setPlaylistMode(PlaylistMode.none);
            } else {
              AppStorage().playboy.setPlaylistMode(PlaylistMode.single);
            }
            setState(() {});
          },
          icon: AppStorage().playboy.state.playlistMode == PlaylistMode.single
              ? const Icon(Icons.repeat_one_on)
              : const Icon(Icons.repeat_one)),
      const SizedBox(
        width: 10,
      ),
      IconButton.filledTonal(
          iconSize: 30,
          onPressed: () {},
          icon: const Icon(Icons.skip_previous_outlined)),
      const SizedBox(
        width: 10,
      ),
      IconButton.filled(
        style: IconButton.styleFrom(
          // backgroundColor: colorScheme.tertiary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        iconSize: 40,
        // color: colorScheme.onTertiary,
        onPressed: () {
          setState(() {
            AppStorage().playboy.playOrPause();
            // AppStorage().playing = AppStorage().playboy.state.playing;
          });
        },
        icon: Icon(
          AppStorage().playing
              ? Icons.pause_circle_outline
              : Icons.play_arrow_outlined,
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton.filledTonal(
          iconSize: 30,
          onPressed: () {},
          icon: const Icon(Icons.skip_next_outlined)),
      const SizedBox(
        width: 10,
      ),
      IconButton(
        icon: const Icon(Icons.view_sidebar_rounded),
        onPressed: () {
          setState(() {});
        },
      ),
      const SizedBox(
        width: 10,
      ),
      IconButton(
          onPressed: () async {
            windowManager.setFullScreen(false);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.fullscreen_exit)),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: colorScheme.secondaryContainer,
                  thumbColor: colorScheme.onSecondaryContainer,
                  trackHeight: 4,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  max: 4,
                  value: AppStorage().playboy.state.rate,
                  onChanged: (value) {
                    // player.seek(Duration(milliseconds: value.toInt()));
                    setState(() {
                      AppStorage().playboy.setRate(value);
                    });
                  },
                )),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  AppStorage().playboy.setRate(1);
                });
              },
              icon: Icon(AppStorage().playboy.state.rate == 1
                  ? Icons.flash_off
                  : Icons.flash_on)),
          const SizedBox(
            width: 16,
          ),
        ],
      )),
    ]);
  }
}
