import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/pages/media/player_menu.dart';
import 'package:playboy/pages/media/player_page.dart';
import 'package:playboy/widgets/menu_button.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FullscreenPlayPage extends StatefulWidget {
  const FullscreenPlayPage({super.key});

  static void Function()? exitFullscreen;

  @override
  FullscreenPlayer createState() => FullscreenPlayer();
}

class FullscreenPlayer extends State<FullscreenPlayPage> {
  late final _controller = AppStorage().controller;

  bool _showControlBar = false;

  bool _isMouseHidden = false;
  Timer? _timer;
  final FocusNode _focusNode = FocusNode();

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isMouseHidden = false;
    });
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _isMouseHidden = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    FullscreenPlayPage.exitFullscreen = () => _exitFullscreen();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    FullscreenPlayPage.exitFullscreen = null;
  }

  @override
  Widget build(BuildContext context) {
    PlayerPage.fn!.requestFocus();
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.08),
      colorScheme.surface,
    );
    return Scaffold(
      body: Stack(
        children: [
          MouseRegion(
            onHover: (_) {
              _resetTimer();
            },
            cursor:
                _isMouseHidden ? SystemMouseCursors.none : MouseCursor.defer,
            child: Video(
              controller: _controller,
              controls: NoVideoControls,
              subtitleViewConfiguration: const SubtitleViewConfiguration(
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _showControlBar ? 0.9 : 0,
              child: MouseRegion(
                onHover: (event) {
                  setState(() {
                    _showControlBar = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _showControlBar = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 90,
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
                                    getProgressString(snapshot.data!),
                                  );
                                } else {
                                  return Text(
                                    getProgressString(AppStorage().position),
                                  );
                                }
                              }),
                          Expanded(child: _buildSeekbarFullscreen()),
                          Text(getProgressString(AppStorage().duration)),
                        ],
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

  void _exitFullscreen() async {
    // https://github.com/leanflutter/window_manager/issues/456
    if (Platform.isWindows && !await windowManager.isMaximized()) {
      windowManager.setSize(AppStorage().windowSize);
      windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      windowManager.setPosition(AppStorage().windowPos);
    } else {
      windowManager.setFullScreen(false);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _buildSeekbarFullscreen() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: StreamBuilder(
        stream: AppStorage().playboy.stream.position,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          return Slider(
            max: AppStorage().duration.inMilliseconds.toDouble(),
            value: AppStorage().seeking
                ? AppStorage().seekingPos
                : max(
                    min(
                        snapshot.hasData
                            ? snapshot.data!.inMilliseconds.toDouble()
                            : AppStorage().position.inMilliseconds.toDouble(),
                        AppStorage().duration.inMilliseconds.toDouble()),
                    0),
            onChanged: (value) {
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
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                setState(() {
                  AppStorage().playboy.setVolume(0);
                });
                AppStorage().settings.volume = 0;
                AppStorage().saveSettings();
              },
              icon: Icon(
                AppStorage().playboy.state.volume == 0
                    ? Icons.volume_off
                    : Icons.volume_up,
              ),
            ),
            SizedBox(
              width: 100,
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: colorScheme.secondaryContainer,
                  thumbColor: colorScheme.secondary,
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
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
            : const Icon(Icons.shuffle),
      ),
      const SizedBox(width: 10),
      IconButton(
        onPressed: () {
          if (AppStorage().playboy.state.playlistMode == PlaylistMode.single) {
            AppStorage().playboy.setPlaylistMode(PlaylistMode.none);
          } else {
            AppStorage().playboy.setPlaylistMode(PlaylistMode.single);
          }
          setState(() {});
        },
        icon: AppStorage().playboy.state.playlistMode == PlaylistMode.single
            ? const Icon(Icons.repeat_one_on)
            : const Icon(Icons.repeat_one),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        onPressed: () {
          AppStorage().playboy.previous();
        },
        icon: const Icon(Icons.skip_previous_outlined),
      ),
      const SizedBox(width: 10),
      IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        iconSize: 32,
        onPressed: () {
          setState(() {
            AppStorage().playboy.playOrPause();
          });
        },
        icon: StreamBuilder(
            stream: AppStorage().playboy.stream.playing,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Icon(
                  snapshot.data!
                      ? Icons.pause_circle_outline
                      : Icons.play_arrow_outlined,
                );
              } else {
                return Icon(
                  AppStorage().playing
                      ? Icons.pause_circle_outline
                      : Icons.play_arrow_outlined,
                );
              }
            }),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        onPressed: () {
          AppStorage().playboy.next();
        },
        icon: const Icon(Icons.skip_next_outlined),
      ),
      const SizedBox(width: 10),
      MenuButton(menuChildren: buildPlayerMenu()),
      const SizedBox(width: 10),
      IconButton(
        onPressed: () async {
          // if (Platform.isWindows && !await windowManager.isMaximized()) {
          //   windowManager.setSize(const Size(900, 700));
          //   windowManager.setTitleBarStyle(TitleBarStyle.hidden);
          //   windowManager.center();
          // } else {
          //   windowManager.setFullScreen(false);
          // }

          // if (!mounted) return;
          // Navigator.pop(context);
          _exitFullscreen();
        },
        icon: const Icon(Icons.fullscreen_exit),
      ),
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 110,
            child: DropdownMenu<double>(
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isDense: true,
                constraints: BoxConstraints(maxHeight: 40),
              ),
              initialSelection: AppStorage().playboy.state.rate,
              onSelected: (value) {
                if (value != null) {
                  AppStorage().playboy.setRate(value);
                  setState(() {});
                }
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 0.25, label: '0.25X'),
                DropdownMenuEntry(value: 0.50, label: '0.50X'),
                DropdownMenuEntry(value: 0.75, label: '0.75X'),
                DropdownMenuEntry(value: 1.00, label: '1.00X'),
                DropdownMenuEntry(value: 1.25, label: '1.25X'),
                DropdownMenuEntry(value: 1.50, label: '1.50X'),
                DropdownMenuEntry(value: 1.75, label: '1.75X'),
                DropdownMenuEntry(value: 2.00, label: '2.00X'),
                DropdownMenuEntry(value: 4.00, label: '4.00X'),
              ],
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () async {
              double? customRate = await showDialog<double>(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController controller = TextEditingController();
                  controller.text = AppStorage().playboy.state.rate.toString();
                  return AlertDialog(
                    title: Text('自定义倍速'.l10n),
                    content: TextField(
                      controller: controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          InputDecoration(labelText: '输入倍速 (e.g. 1.2)'.l10n),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: Text('取消'.l10n),
                      ),
                      TextButton(
                        onPressed: () {
                          double? rate = double.tryParse(controller.text);
                          if (rate != null) {
                            Navigator.of(context).pop(rate);
                          } else {
                            Navigator.of(context).pop(null);
                          }
                        },
                        child: Text('确定'.l10n),
                      ),
                    ],
                  );
                },
              );
              if (customRate != null && customRate > 0) {
                setState(() {
                  AppStorage().playboy.setRate(customRate);
                  AppStorage().settings.speed = customRate;
                  AppStorage().saveSettings();
                });
              }
            },
            icon: Icon(
              AppStorage().playboy.state.rate == 1
                  ? Icons.flash_off
                  : Icons.flash_on,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      )),
    ]);
  }
}
