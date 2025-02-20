import 'dart:async';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit_video/basic/basic_video_controller.dart';
import 'package:path/path.dart' as p;
// import 'package:screen_retriever/screen_retriever.dart';
// import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/basic_video.dart';
import 'package:playboy/pages/media/player_menu.dart';
// import 'package:playboy/pages/media/fullscreen_play_page.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/player_list.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({
    super.key,
    required this.fullscreen,
  });

  final bool fullscreen;

  @override
  PlayerPageState createState() => PlayerPageState();
}

class PlayerPageState extends State<PlayerPage> {
  BasicVideoController controller = AppStorage().controller;

  bool _menuExpanded = false;
  // bool _videoMode = !AppStorage().settings.defaultMusicMode;
  int _curPanel = 0;

  // bool _showControlBar = false;
  bool _isMouseHidden = false;
  Timer? _timer;

  void _resetCursorHideTimer() {
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
  }

  @override
  void dispose() {
    super.dispose();
    if (!AppStorage().settings.playAfterExit) {
      AppStorage().closeMedia();
    }
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  // flex: 3,
                  child: Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildPlayer(colorScheme),
                  ),
                ),
                _menuExpanded
                    ? Container(
                        padding: widget.fullscreen
                            ? null
                            : const EdgeInsets.only(left: 10),
                        width: 300,
                        child: _buildSidePanel(
                          colorScheme,
                          backgroundColor,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          ..._buildButtomBar(context, colorScheme),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  List<Widget> _buildButtomBar(BuildContext context, ColorScheme colorScheme) {
    return [
      SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        height: 25,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 60,
              child: StreamBuilder(
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
                },
              ),
            ),
            Expanded(child: _buildSeekbar()),
            Container(
              alignment: Alignment.center,
              width: 60,
              child: StreamBuilder(
                stream: AppStorage().playboy.stream.duration,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      getProgressString(snapshot.data!),
                    );
                  } else {
                    return Text(
                      getProgressString(AppStorage().duration),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 50,
        child: _buildControlbar(colorScheme),
      ),
    ];
  }

  Widget _buildPlayer(ColorScheme colorScheme) {
    return MInteractiveWrapper(
      menuController: MenuController(),
      menuChildren: buildPlayerMenu(),
      onTap: null,
      borderRadius: 18,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.fullscreen ? 0 : 18),
        ),
        child: MouseRegion(
          onHover: (_) {
            _resetCursorHideTimer();
          },
          cursor: _isMouseHidden ? SystemMouseCursors.none : MouseCursor.defer,
          child: Stack(
            children: [
              const ColoredBox(
                color: Colors.black,
                child: SizedBox.expand(),
              ),
              SizedBox.expand(
                child: BasicVideo(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekbar() {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderThemeData(
        year2023: false,
        trackHeight: 4,
        thumbColor: colorScheme.secondary,
        activeTrackColor: colorScheme.secondary,
        thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
        overlayShape: SliderComponentShape.noOverlay,
      ),
      child: StreamBuilder(
        stream: AppStorage().playboy.stream.position,
        builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
          return Slider(
            max: AppStorage().duration.inMilliseconds.toDouble(),
            value: AppStorage().seeking
                ? AppStorage().seekingPos
                : bounded(
                    0,
                    snapshot.hasData
                        ? snapshot.data!.inMilliseconds.toDouble()
                        : AppStorage().position.inMilliseconds.toDouble(),
                    AppStorage().duration.inMilliseconds.toDouble(),
                  ),
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
                  .then(
                    (_) => {
                      setState(() {
                        AppStorage().seeking = false;
                      })
                    },
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildControlbar(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 6),
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
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                ),
              ),
              SizedBox(
                width: 80,
                child: SliderTheme(
                  data: SliderThemeData(
                    year2023: false,
                    activeTrackColor: colorScheme.secondaryContainer,
                    thumbColor: colorScheme.secondary,
                    trackHeight: 4,
                    thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
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
            AppStorage().closeMedia().then((_) {
              setState(() {});
            });
          },
          icon: const Icon(Icons.stop_circle_outlined),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              AppStorage().shuffle = !AppStorage().shuffle;
              AppStorage().playboy.setShuffle(AppStorage().shuffle);
            });
          },
          icon: AppStorage().shuffle
              ? const Icon(Icons.shuffle_on_rounded)
              : const Icon(Icons.shuffle_rounded),
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
              ? const Icon(Icons.repeat_one_on_rounded)
              : const Icon(Icons.repeat_one_rounded),
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
            // backgroundColor: colorScheme.secondary,
            // foregroundColor: colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          iconSize: 30,
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
        const SizedBox(
          width: 10,
        ),
        IconButton.filledTonal(
          onPressed: () {
            AppStorage().playboy.next();
          },
          icon: const Icon(Icons.skip_next_outlined),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          icon: const Icon(
            Icons.menu,
            weight: 550,
          ),
          onPressed: () {
            _handlePanelSelection(1);
          },
        ),
        IconButton(
          onPressed: () {
            _handlePanelSelection(0);
          },
          icon: const Icon(Icons.video_settings),
        ),
        IconButton(
          onPressed: () {
            _handlePanelSelection(2);
          },
          icon: const Icon(Icons.description_outlined),
        ),
        const Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: null,
                icon: Icon(Icons.alarm),
              ),
              // IconButton(
              //   onPressed: () async {
              //     // https://github.com/leanflutter/window_manager/issues/456
              //     if (Platform.isWindows &&
              //         !await windowManager.isMaximized()) {
              //       AppStorage().windowPos = await windowManager.getPosition();
              //       AppStorage().windowSize = await windowManager.getSize();
              //       var info = (await screenRetriever.getPrimaryDisplay());
              //       await windowManager.setAsFrameless();
              //       await windowManager.setPosition(Offset.zero);
              //       await windowManager.setSize(info.size);
              //     } else {
              //       windowManager.setFullScreen(true);
              //     }

              //     if (!mounted) return;
              //     Navigator.of(context, rootNavigator: true).push(
              //       PageRouteBuilder(
              //         pageBuilder: (context, animation1, animation2) =>
              //             const FullscreenPlayPage(),
              //         transitionDuration: Duration.zero,
              //         reverseTransitionDuration: Duration.zero,
              //       ),
              //     );
              //   },
              //   icon: const Icon(Icons.open_in_full_rounded),
              // ),
              SizedBox(width: 6),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePanelSelection(int id) {
    if (!_menuExpanded) {
      setState(() {
        _menuExpanded = true;
        _curPanel = id;
      });
    } else if (_curPanel == id) {
      setState(() {
        _menuExpanded = false;
      });
    } else {
      setState(() {
        _curPanel = id;
      });
    }
  }

  Widget _buildSidePanel(ColorScheme colorScheme, Color backgroundColor) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(widget.fullscreen ? 0 : 18),
      ),
      child: [
        _buildConfigurationsPanel(colorScheme, backgroundColor),
        _buildPlaylistPanel(colorScheme, backgroundColor),
        _buildCommandsPanel(colorScheme, backgroundColor),
      ][_curPanel],
    );
  }

  Widget _buildPlaylistPanel(ColorScheme colorScheme, Color backgroundColor) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
        toolbarHeight: 46,
        scrolledUnderElevation: 0,
        title: Text(
          '播放列表'.l10n,
          style: TextStyle(color: colorScheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _menuExpanded = false;
              });
            },
            icon: Icon(
              Icons.close,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: AppStorage().playboy.stream.playlist,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var src = AppStorage().playboy.state.playlist.medias[index].uri;
              return SizedBox(
                height: 46,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          AppStorage().playboy.jump(index);
                        },
                        child: PlayerListCard(
                          info: PlayItem(
                            source: src,
                            cover: null,
                            title: p.basenameWithoutExtension(src),
                          ),
                          isPlaying: index == AppStorage().playingIndex,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        var len =
                            AppStorage().playboy.state.playlist.medias.length;
                        if (index == AppStorage().playingIndex) {
                          if (len == 1) {
                            AppStorage().closeMedia();
                          } else if (len - 1 == index) {
                            AppStorage().playboy.previous();
                          } else {
                            AppStorage().playboy.next();
                          }
                        }
                        AppStorage().playboy.remove(index);
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              );
            },
            itemCount: AppStorage().playboy.state.playlist.medias.length,
          );
        },
      ),
    );
  }

  Widget _buildConfigurationsPanel(
    ColorScheme colorScheme,
    Color backgroundColor,
  ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
        toolbarHeight: 46,
        scrolledUnderElevation: 0,
        title: Text(
          '视频选项',
          style: TextStyle(color: colorScheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _menuExpanded = false;
              });
            },
            icon: Icon(
              Icons.close,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      AppStorage().playboy.setRate(1);
                    });
                  },
                  icon: const Icon(Icons.flash_on_rounded),
                ),
                Expanded(
                  child: Slider(
                    min: 0.25,
                    max: 8,
                    divisions: 31,
                    label: AppStorage().playboy.state.rate.toString(),
                    value: bounded(0.25, AppStorage().playboy.state.rate, 8),
                    onChanged: (value) {
                      setState(() {
                        AppStorage().playboy.setRate(value);
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsPanel(
    ColorScheme colorScheme,
    Color backgroundColor,
  ) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
        toolbarHeight: 46,
        scrolledUnderElevation: 0,
        title: Text(
          '命令',
          style: TextStyle(color: colorScheme.primary),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _menuExpanded = false;
              });
            },
            icon: Icon(
              Icons.close,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      // body: ListView(
      //   children: [
      //     ListTile(
      //       title: const Text('show text'),
      //       onTap: () {
      //         AppStorage().playboy.command([
      //           'show-text',
      //           'hello',
      //         ]);
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
