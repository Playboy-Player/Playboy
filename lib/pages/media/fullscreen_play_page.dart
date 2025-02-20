import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/basic_video.dart';
import 'package:playboy/pages/media/player_menu.dart';
import 'package:playboy/widgets/menu/menu_button.dart';

class FullscreenPlayPage extends StatefulWidget {
  const FullscreenPlayPage({super.key});

  static void Function()? exitFullscreen;

  @override
  FullscreenPlayer createState() => FullscreenPlayer();
}

class FullscreenPlayer extends State<FullscreenPlayPage> {
  late final _controller = App().controller;

  bool _showControlBar = false;
  bool _isMouseHidden = false;
  Timer? _timer;
  // final FocusNode _focusNode = FocusNode();

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
    // _focusNode.dispose();
    _timer?.cancel();
    FullscreenPlayPage.exitFullscreen = null;
  }

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                const ColoredBox(
                  color: Colors.black,
                  child: SizedBox.expand(),
                ),
                SizedBox.expand(
                  child: BasicVideo(controller: _controller),
                ),
              ],
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
                              stream: App().playboy.stream.position,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    getProgressString(snapshot.data!),
                                  );
                                } else {
                                  return Text(
                                    getProgressString(App().position),
                                  );
                                }
                              }),
                          Expanded(child: _buildSeekbarFullscreen()),
                          Text(getProgressString(App().duration)),
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
      windowManager.setSize(App().windowSize);
      windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      windowManager.setPosition(App().windowPos);
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
        stream: App().playboy.stream.position,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          return Slider(
            max: App().duration.inMilliseconds.toDouble(),
            value: App().seeking
                ? App().seekingPos
                : max(
                    min(
                        snapshot.hasData
                            ? snapshot.data!.inMilliseconds.toDouble()
                            : App().position.inMilliseconds.toDouble(),
                        App().duration.inMilliseconds.toDouble()),
                    0),
            onChanged: (value) {
              setState(() {
                App().seekingPos = value;
              });
            },
            onChangeStart: (value) {
              setState(() {
                App().seeking = true;
              });
            },
            onChangeEnd: (value) {
              App()
                  .playboy
                  .seek(Duration(milliseconds: value.toInt()))
                  .then((value) => {
                        setState(() {
                          App().seeking = false;
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
                  App().playboy.setVolume(0);
                });
                App().settings.volume = 0;
                App().saveSettings();
              },
              icon: Icon(
                App().playboy.state.volume == 0
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
                  value: App().playboy.state.volume,
                  onChanged: (value) {
                    setState(() {
                      App().playboy.setVolume(value);
                    });
                  },
                  onChangeEnd: (value) {
                    setState(() {});
                    App().settings.volume = value;
                    App().saveSettings();
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
            App().shuffle = !App().shuffle;
          });
        },
        icon: App().shuffle
            ? const Icon(Icons.shuffle_on)
            : const Icon(Icons.shuffle),
      ),
      const SizedBox(width: 10),
      IconButton(
        onPressed: () {
          if (App().playboy.state.playlistMode == PlaylistMode.single) {
            App().playboy.setPlaylistMode(PlaylistMode.none);
          } else {
            App().playboy.setPlaylistMode(PlaylistMode.single);
          }
          setState(() {});
        },
        icon: App().playboy.state.playlistMode == PlaylistMode.single
            ? const Icon(Icons.repeat_one_on)
            : const Icon(Icons.repeat_one),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        onPressed: () {
          App().playboy.previous();
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
            App().playboy.playOrPause();
          });
        },
        icon: StreamBuilder(
            stream: App().playboy.stream.playing,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Icon(
                  snapshot.data!
                      ? Icons.pause_circle_outline
                      : Icons.play_arrow_outlined,
                );
              } else {
                return Icon(
                  App().playing
                      ? Icons.pause_circle_outline
                      : Icons.play_arrow_outlined,
                );
              }
            }),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        onPressed: () {
          App().playboy.next();
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
              initialSelection: App().playboy.state.rate,
              onSelected: (value) {
                if (value != null) {
                  App().playboy.setRate(value);
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
                  controller.text = App().playboy.state.rate.toString();
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
                  App().playboy.setRate(customRate);
                  App().settings.speed = customRate;
                  App().saveSettings();
                });
              }
            },
            icon: Icon(
              App().playboy.state.rate == 1 ? Icons.flash_off : Icons.flash_on,
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
