import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/basic/basic_video_controller.dart';
import 'package:path/path.dart' as p;
import 'package:media_kit/media_kit.dart';

import 'package:playboy/backend/actions.dart' as actions;
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/basic_video.dart';
import 'package:playboy/pages/media/player_menu.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/player_list.dart';
import 'package:playboy/backend/ml/subtitle_generator.dart';

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
  BasicVideoController controller = App().controller;

  bool _menuExpanded = false;
  int _curPanel = 0;

  bool _showControlBar = false;
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
    if (!App().settings.playAfterExit) {
      App().closeMedia();
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
      body: widget.fullscreen
          ? Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: _buildPlayer(colorScheme),
                      ),
                    ),
                    _buildSidePanel(colorScheme, backgroundColor),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: _showControlBar ? 0.9 : 0,
                    duration: const Duration(milliseconds: 100),
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
                        color: backgroundColor,
                        height: 90,
                        child: Column(
                          children: _buildButtomBar(context, colorScheme),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: _buildPlayer(colorScheme),
                        ),
                      ),
                      _buildSidePanel(colorScheme, backgroundColor),
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
    Widget buildSeekbar() {
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
          stream: App().playboy.stream.position,
          builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
            return Slider(
              max: App().duration.inMilliseconds.toDouble(),
              value: App().seeking
                  ? App().seekingPos
                  : bounded(
                      0,
                      snapshot.hasData
                          ? snapshot.data!.inMilliseconds.toDouble()
                          : App().position.inMilliseconds.toDouble(),
                      App().duration.inMilliseconds.toDouble(),
                    ),
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
                App().playboy.seek(Duration(milliseconds: value.toInt())).then(
                      (_) => {
                        setState(() {
                          App().seeking = false;
                        })
                      },
                    );
              },
            );
          },
        ),
      );
    }

    Widget buildControlbar(ColorScheme colorScheme) {
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
                      App().playboy.setVolume(0);
                    });
                    App().settings.volume = 0;
                    App().saveSettings();
                  },
                  icon: Icon(
                    App().playboy.state.volume == 0
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
              App().closeMedia().then((_) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.stop_circle_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                App().shuffle = !App().shuffle;
                App().playboy.setShuffle(App().shuffle);
              });
            },
            icon: App().shuffle
                ? const Icon(Icons.shuffle_on_rounded)
                : const Icon(Icons.shuffle_rounded),
          ),
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
                ? const Icon(Icons.repeat_one_on_rounded)
                : const Icon(Icons.repeat_one_rounded),
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
              // backgroundColor: colorScheme.secondary,
              // foregroundColor: colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            iconSize: 30,
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
          const SizedBox(
            width: 10,
          ),
          IconButton.filledTonal(
            onPressed: () {
              App().playboy.next();
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
            icon: const Icon(Icons.slow_motion_video),
          ),
          IconButton(
            onPressed: () {
              _handlePanelSelection(2);
            },
            icon: const Icon(Icons.subtitles_outlined),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const IconButton(
                  onPressed: null,
                  icon: Icon(Icons.alarm),
                ),
                IconButton(
                  onPressed: () {
                    App().executeAction(actions.toggleFullscreen);
                  },
                  icon: const Icon(Icons.open_in_full_rounded),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ],
      );
    }

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
                },
              ),
            ),
            Expanded(child: buildSeekbar()),
            Container(
              alignment: Alignment.center,
              width: 60,
              child: StreamBuilder(
                stream: App().playboy.stream.duration,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      getProgressString(snapshot.data!),
                    );
                  } else {
                    return Text(
                      getProgressString(App().duration),
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
        child: buildControlbar(colorScheme),
      ),
    ];
  }

  Widget _buildPlayer(ColorScheme colorScheme) {
    return MInteractiveWrapper(
      menuController: MenuController(),
      // TODO: show dialog without context
      menuChildren: buildPlayerMenu(context),
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

  Widget _buildSidePanel(
    ColorScheme colorScheme,
    Color backgroundColor,
  ) {
    Widget buildSidePanelContent(
      ColorScheme colorScheme,
      Color backgroundColor,
    ) {
      return ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.fullscreen ? 0 : 18),
        ),
        child: [
          _buildConfigurationsPanel(colorScheme, backgroundColor),
          _buildPlaylistPanel(colorScheme, backgroundColor),
          _buildSubtitlePanel(colorScheme, backgroundColor),
        ][_curPanel],
      );
    }

    return _menuExpanded
        ? Container(
            padding: widget.fullscreen ? null : const EdgeInsets.only(left: 10),
            width: 300,
            child: buildSidePanelContent(
              colorScheme,
              backgroundColor,
            ),
          )
        : const SizedBox();
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
        stream: App().playboy.stream.playlist,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var src = App().playboy.state.playlist.medias[index].uri;
              return SizedBox(
                height: 46,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          App().playboy.jump(index);
                        },
                        child: PlayerListCard(
                          info: PlayItem(
                            source: src,
                            cover: null,
                            title: p.basenameWithoutExtension(src),
                          ),
                          isPlaying: index == App().playingIndex,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        var len = App().playboy.state.playlist.medias.length;
                        if (index == App().playingIndex) {
                          if (len == 1) {
                            App().closeMedia();
                          } else if (len - 1 == index) {
                            App().playboy.previous();
                          } else {
                            App().playboy.next();
                          }
                        }
                        App().playboy.remove(index);
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
            itemCount: App().playboy.state.playlist.medias.length,
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
                      App().playboy.setRate(1);
                    });
                  },
                  icon: const Icon(Icons.flash_on_rounded),
                ),
                Expanded(
                  child: Slider(
                    min: 0.25,
                    max: 8,
                    divisions: 31,
                    label: App().playboy.state.rate.toString(),
                    value: bounded(0.25, App().playboy.state.rate, 8),
                    onChanged: (value) {
                      setState(() {
                        App().playboy.setRate(value);
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

  Widget _buildSubtitlePanel(
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
          '字幕'.l10n,
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
          ListTile(
            title: Text('生成字幕'.l10n),
            onTap: () async {
              SubtitleGenerator subGenerator = SubtitleGenerator("medium-q5_0");
              subGenerator.ensureInitialized();
              if (App().mediaPath != null) {
                var subtitle = await subGenerator.genSubtitle(App().mediaPath!);
                debugPrint("Generated subtitle: $subtitle");
                App().playboy.setSubtitleTrack(SubtitleTrack.data(subtitle));
              } else {
                debugPrint("No media is playing");
              }
            },
          ),
        ],
      ),
    );
  }
}
