import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/basic/video_controller.dart';
import 'package:path/path.dart' as p;
import 'package:media_kit/media_kit.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/media_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
import 'package:playboy/pages/media/seekbar_builder.dart';
import 'package:playboy/widgets/basic_video.dart';
import 'package:playboy/pages/media/player_menu.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/time_utils.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/menu/menu_item.dart';
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
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.appBackground,
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
                    _buildSidePanel(colorScheme, colorScheme.appBackground),
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
                        color: colorScheme.appBackground,
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
                      _buildSidePanel(colorScheme, colorScheme.appBackground),
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
          // ignore: deprecated_member_use
          year2023: false,
          trackHeight: 4,
          thumbColor: colorScheme.secondary,
          activeTrackColor: colorScheme.secondary,
          thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
          overlayShape: SliderComponentShape.noOverlay,
        ),
        child: buildMediaSeekbar(() {
          setState(() {});
        }),
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
                      App().player.setVolume(0);
                    });
                    App().settings.volume = 0;
                    App().saveSettings();
                  },
                  icon: Icon(
                    App().player.state.volume == 0
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: SliderTheme(
                    data: SliderThemeData(
                      // ignore: deprecated_member_use
                      year2023: false,
                      activeTrackColor: colorScheme.secondaryContainer,
                      thumbColor: colorScheme.secondary,
                      trackHeight: 4,
                      thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
                      overlayShape: SliderComponentShape.noOverlay,
                    ),
                    child: StreamBuilder(
                        stream: App().player.stream.volume,
                        builder: (context, snapshot) {
                          return Slider(
                            max: 100,
                            value: App().player.state.volume,
                            onChanged: (value) {
                              setState(() {
                                App().player.setVolume(value);
                              });
                            },
                            onChangeEnd: (value) {
                              setState(() {});
                              App().settings.volume = value;
                              App().saveSettings();
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              App().player.stop();
            },
            icon: const Icon(Icons.stop_circle_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                // App().shuffle = !App().shuffle;
                var shuffle = App().player.isShuffleEnabled;
                App().player.setShuffle(!shuffle);
                setState(() {});
              });
            },
            icon: App().player.isShuffleEnabled
                ? const Icon(Icons.shuffle_on_rounded)
                : const Icon(Icons.shuffle_rounded),
          ),
          StreamBuilder(
            stream: App().player.stream.playlistMode,
            builder: (context, _) {
              return IconButton(
                onPressed: () {
                  switch (App().player.state.playlistMode) {
                    case PlaylistMode.loop:
                      App().player.setPlaylistMode(PlaylistMode.single);
                    case PlaylistMode.single:
                      App().player.setPlaylistMode(PlaylistMode.none);
                    case PlaylistMode.none:
                      App().player.setPlaylistMode(PlaylistMode.loop);
                  }
                },
                icon: Icon(
                  switch (App().player.state.playlistMode) {
                    PlaylistMode.loop => Icons.repeat_on_rounded,
                    PlaylistMode.single => Icons.repeat_one_on_rounded,
                    PlaylistMode.none => Icons.repeat_rounded,
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 10),
          IconButton.filledTonal(
            onPressed: () {
              App().player.previous();
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
                App().player.playOrPause();
              });
            },
            icon: StreamBuilder(
                stream: App().player.stream.playing,
                builder: (context, snapshot) {
                  return Icon(
                    App().player.state.playing
                        ? Icons.pause_circle_outline
                        : Icons.play_arrow_outlined,
                  );
                }),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton.filledTonal(
            onPressed: () {
              App().player.next();
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
              _handlePanelSelection(4);
            },
            icon: const Icon(Icons.subtitles_outlined),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _handlePanelSelection(2);
                  },
                  icon: const Icon(Icons.auto_awesome_outlined),
                ),
                IconButton(
                  onPressed: () {
                    App().executeAction('togglePlayer');
                  },
                  icon: const Icon(Icons.video_library_outlined),
                ),
                IconButton(
                  onPressed: () {
                    App().executeAction('toggleFullscreen');
                  },
                  icon: const Icon(Icons.open_in_full_outlined),
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
                stream: App().player.stream.position,
                builder: (context, snapshot) {
                  return Text(
                    getProgressString(App().player.state.position),
                  );
                },
              ),
            ),
            Expanded(child: buildSeekbar()),
            Container(
              alignment: Alignment.center,
              width: 60,
              child: StreamBuilder(
                stream: App().player.stream.duration,
                builder: (context, snapshot) {
                  return Text(
                    getProgressString(App().player.state.duration),
                  );
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
      menuChildren: [
        const SizedBox(height: 10),
        ...buildPlayerMenu(context),
        const Divider(),
        MMenuItem(
          icon: Icons.menu,
          label: '播放列表'.l10n,
          onPressed: () {
            _handlePanelSelection(1);
          },
        ),
        MMenuItem(
          icon: Icons.slow_motion_video,
          label: '视频选项'.l10n,
          onPressed: () {
            _handlePanelSelection(0);
          },
        ),
        MMenuItem(
          icon: Icons.subtitles_outlined,
          label: '字幕选项'.l10n,
          onPressed: () {
            _handlePanelSelection(4);
          },
        ),
        MMenuItem(
          icon: Icons.info_outline,
          label: '统计信息'.l10n,
          onPressed: () {
            _handlePanelSelection(3);
          },
        ),
        MMenuItem(
          icon: Icons.auto_awesome_outlined,
          label: 'Whisper',
          onPressed: () {
            _handlePanelSelection(2);
          },
        ),
        const Divider(),
        SubmenuButton(
          leadingIcon: const Icon(
            Icons.bug_report_outlined,
            size: 18,
          ),
          menuChildren: [
            const SizedBox(height: 10),
            MMenuItem(
              icon: Icons.bug_report_outlined,
              label: '以 UI 显示尺寸输出'.l10n,
              onPressed: () {
                App().refreshVO();
              },
            ),
            MMenuItem(
              icon: Icons.bug_report_outlined,
              label: '以原始视频显示输出'.l10n,
              onPressed: () {
                App().restoreVO();
              },
            ),
            const SizedBox(height: 10)
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text('调试'.l10n),
          ),
        ),
        const SizedBox(height: 10),
      ],
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
          _buildWhisperPanel(colorScheme, backgroundColor),
          _buildStatisticPanel(colorScheme, backgroundColor),
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

  // TODO: show chapter-list
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
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
          ),
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
        stream: App().player.stream.playlist,
        builder: (context, snapshot) {
          if (App().player.state.playlist.medias.isEmpty) {
            return Center(
              child: Text(
                '未在播放'.l10n,
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              var src = App().player.state.playlist.medias[index].uri;
              return SizedBox(
                height: 46,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          App().player.jump(index);
                        },
                        child: PlayerListCard(
                          info: PlayItem(
                            source: src,
                            title: p.basenameWithoutExtension(src),
                          ),
                          isPlaying: index == App().player.state.playlist.index,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        var len = App().player.state.playlist.medias.length;
                        if (index == App().player.state.playlist.index) {
                          if (len == 1) {
                            App().player.stop();
                          } else if (len - 1 == index) {
                            App().player.previous();
                          } else {
                            App().player.next();
                          }
                        }
                        App().player.remove(index);
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
            itemCount: App().player.state.playlist.medias.length,
          );
        },
      ),
    );
  }

  bool _videoTrackConfig = false;
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
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
          ),
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
      body: CustomScrollView(
        slivers: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.primaryContainer.withValues(alpha: 0.4),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        _videoTrackConfig = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _videoTrackConfig
                            ? null
                            : colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note_outlined,
                            size: 20,
                            color: _videoTrackConfig
                                ? null
                                : colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '音频'.l10n,
                            style: TextStyle(
                              color: _videoTrackConfig
                                  ? null
                                  : colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        _videoTrackConfig = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _videoTrackConfig
                            ? colorScheme.primaryContainer
                            : null,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.movie_creation_outlined,
                            size: 20,
                            color: _videoTrackConfig
                                ? colorScheme.onPrimaryContainer
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '视频'.l10n,
                            style: TextStyle(
                              color: _videoTrackConfig
                                  ? colorScheme.onPrimaryContainer
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          ValueListenableBuilder(
            valueListenable:
                _videoTrackConfig ? App().player.vid : App().player.aid,
            builder: (context, id, _) {
              return SliverList.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  var info = _videoTrackConfig
                      ? App().player.state.tracks.video[index]
                      : App().player.state.tracks.audio[index];
                  var title =
                      '${info.id}. ${info.language ?? ''}_${info.title ?? ''}';
                  if (info.id == 'auto') title = '自动选择'.l10n;
                  if (info.id == 'no') title = '停止输出'.l10n;
                  return SizedBox(
                    height: 30,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        App().player.setProperty(
                            _videoTrackConfig ? 'vid' : 'aid', info.id);
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(title),
                          ),
                          if (info.id == id.toString())
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                            ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _videoTrackConfig
                    ? App().player.state.tracks.video.length
                    : App().player.state.tracks.audio.length,
              );
            },
          ),
          const SizedBox(height: 10).toSliver(),
          Text(
            '速度和延迟'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.speed,
            builder: (context, speed, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认速度'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setRate(1);
                      });
                    },
                    icon: const Icon(Icons.flash_on_rounded),
                  ),
                  Expanded(
                    child: Slider(
                      value: _toSliderValue(bounded(0, speed, 16)),
                      onChanged: (value) {
                        App()
                            .player
                            .setRate(bounded(0.01, _toSpeedValue(value), 16));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    child: FittedBox(
                      child: Text(
                        '${(speed >= 0 ? '+' : '')}${speed.toStringAsFixed(2)}x',
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.audioDelay,
            builder: (context, audioDelay, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '重置音频延迟'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('audio-delay', '0');
                      });
                    },
                    icon: const Icon(Icons.music_note_outlined),
                  ),
                  Expanded(
                    child: Slider(
                      min: -30,
                      max: 30,
                      value: bounded(-30, audioDelay, 30),
                      onChanged: (value) {
                        App()
                            .player
                            .setProperty('audio-delay', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    child: FittedBox(
                      child: Text(
                        '${(audioDelay >= 0 ? '+' : '')}${audioDelay.toStringAsFixed(2)}s',
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          Text(
            '均衡器'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.brightness,
            builder: (context, brightness, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认亮度'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('brightness', '0');
                      });
                    },
                    icon: const Icon(Icons.brightness_6_outlined),
                  ),
                  Expanded(
                    child: Slider(
                      min: -100,
                      max: 100,
                      value: bounded(-100, brightness * 1.0, 100),
                      onChanged: (value) {
                        App()
                            .player
                            .setProperty('brightness', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: FittedBox(
                      child: Text(
                        (brightness >= 0 ? '+' : '') + brightness.toString(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.contrast,
            builder: (context, contrast, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认对比度'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('contrast', '0');
                      });
                    },
                    icon: const Icon(Icons.contrast),
                  ),
                  Expanded(
                    child: Slider(
                      min: -100,
                      max: 100,
                      value: bounded(-100, contrast * 1.0, 100),
                      onChanged: (value) {
                        App().player.setProperty('contrast', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: FittedBox(
                      child: Text(
                        (contrast >= 0 ? '+' : '') + contrast.toString(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.saturation,
            builder: (context, saturation, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认饱和度'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('saturation', '0');
                      });
                    },
                    icon: const Icon(Icons.color_lens),
                  ),
                  Expanded(
                    child: Slider(
                      min: -100,
                      max: 100,
                      value: bounded(-100, saturation * 1.0, 100),
                      onChanged: (value) {
                        App().player.setProperty(
                              'saturation',
                              value.toString(),
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: FittedBox(
                      child: Text(
                        (saturation >= 0 ? '+' : '') + saturation.toString(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.gamma,
            builder: (context, gamma, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认 gamma'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('gamma', '0');
                      });
                    },
                    icon: const Icon(Icons.blur_circular_outlined),
                  ),
                  Expanded(
                    child: Slider(
                      min: -100,
                      max: 100,
                      value: bounded(-100, gamma * 1.0, 100),
                      onChanged: (value) {
                        App().player.setProperty('gamma', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: FittedBox(
                      child: Text((gamma >= 0 ? '+' : '') + gamma.toString()),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.hue,
            builder: (context, hue, _) {
              return Row(
                children: [
                  IconButton(
                    // tooltip: '恢复默认色调'.l10n,
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('hue', '0');
                      });
                    },
                    icon: const Icon(Icons.invert_colors),
                  ),
                  Expanded(
                    child: Slider(
                      min: -100,
                      max: 100,
                      value: bounded(-100, hue * 1.0, 100),
                      onChanged: (value) {
                        App().player.setProperty('hue', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: FittedBox(
                      child: Text((hue >= 0 ? '+' : '') + hue.toString()),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          Text(
            '视频输出'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          // FIXME: UI size not correct
          OutlinedButton.icon(
            onPressed: () {
              App().refreshVO();
            },
            icon: const Icon(Icons.high_quality_outlined),
            label: Text('以 UI 显示尺寸输出'.l10n),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          OutlinedButton.icon(
            onPressed: () {
              App().restoreVO();
            },
            icon: const Icon(Icons.settings_backup_restore),
            label: Text('以原始视频尺寸输出'.l10n),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
        ]
            .map(
              (v) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: v,
              ),
            )
            .toList(),
      ),
    );
  }

  double _toSliderValue(double speed) {
    return speed < 1 ? (speed / 2) : (0.5 + (speed - 1) / 30);
  }

  double _toSpeedValue(double t) {
    return t < 0.5 ? (2 * t) : (1 + 30 * (t - 0.5));
  }

  Widget _buildStatisticPanel(
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
          '统计信息'.l10n,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Text(
            '文件'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ),
          StreamBuilder(
            stream: App().player.stream.playlist,
            builder: (context, _) {
              if (App().player.state.playlist.medias.isEmpty) {
                return Text(
                  '未在播放'.l10n,
                  style:
                      TextStyle(backgroundColor: colorScheme.primaryContainer),
                );
              }
              return Text(App().player.state.playlist.current.uri);
            },
          ),
          Text(
            '音频'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ),
          StreamBuilder(
            stream: App().player.stream.audioParams,
            builder: (context, _) {
              return Text(App().player.state.audioParams.toString());
            },
          ),
          Text(
            '视频'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ),
          StreamBuilder(
            stream: App().player.stream.videoParams,
            builder: (context, _) {
              return Text(App().player.state.videoParams.toString());
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.info_outline),
            label: Text('切换 mpv-stat 统计信息'.l10n),
            onPressed: () {
              App().player.command(['script-binding', 'display-stats-toggle']);
            },
          ),
        ],
      ),
    );
  }

  final TextEditingController _whisperData = TextEditingController();

  Widget _buildWhisperPanel(
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
          'Whisper',
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_awesome_outlined),
                  label: Text('开始'.l10n),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: Text('停止'.l10n),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 30,
                child: Checkbox(value: true, onChanged: (value) {}),
              ),
              Expanded(child: Text('自动应用字幕到播放器'.l10n)),
            ],
          ),
          const SizedBox(height: 10),
          // progress from 0 to 1
          const LinearProgressIndicator(
            value: 0,
            // ignore: deprecated_member_use
            year2023: false,
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 20,
            controller: _whisperData,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
            label: Text('导出 srt 文件'.l10n),
          ),
        ],
      ),
    );
  }

  bool _secondarySubConfig = false;
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
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
          ),
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
      body: CustomScrollView(
        slivers: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colorScheme.primaryContainer.withValues(alpha: 0.4),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        _secondarySubConfig = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _secondarySubConfig
                            ? null
                            : colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.looks_one_outlined,
                            size: 20,
                            color: _secondarySubConfig
                                ? null
                                : colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '字幕 1',
                            style: TextStyle(
                              color: _secondarySubConfig
                                  ? null
                                  : colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      setState(() {
                        _secondarySubConfig = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _secondarySubConfig
                            ? colorScheme.primaryContainer
                            : null,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.looks_two_outlined,
                            size: 20,
                            color: _secondarySubConfig
                                ? colorScheme.onPrimaryContainer
                                : null,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '字幕 2',
                            style: TextStyle(
                              color: _secondarySubConfig
                                  ? colorScheme.onPrimaryContainer
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          Text(
            '轨道'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          ValueListenableBuilder(
            valueListenable: _secondarySubConfig
                ? App().player.secondarySid
                : App().player.sid,
            builder: (context, id, _) {
              return SliverList.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  var info = App().player.state.tracks.subtitle[index];
                  var title =
                      '${info.id}. ${info.language ?? ''}_${info.title ?? ''}';
                  if (info.id == 'auto') title = '自动选择'.l10n;
                  if (info.id == 'no') title = '空白字幕'.l10n;
                  return SizedBox(
                    height: 30,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        App().player.setProperty(
                            _secondarySubConfig ? 'secondary-sid' : 'sid',
                            info.id);
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(title),
                          ),
                          if (info.id == id.toString())
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                            ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: App().player.state.tracks.subtitle.length,
              );
            },
          ),
          const SizedBox(height: 10).toSliver(),
          Text(
            '样式与延迟'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          Row(
            children: [
              SizedBox(
                width: 40,
                child: ValueListenableBuilder(
                  valueListenable: App().player.subVisibility,
                  builder: (context, v, _) {
                    return Checkbox(
                      value: v,
                      onChanged: (value) {
                        if (value == null) return;
                        if (value) {
                          App().player.setProperty('sub-visibility', 'yes');
                        } else {
                          App().player.setProperty('sub-visibility', 'no');
                        }
                      },
                    );
                  },
                ),
              ),
              Expanded(child: Text('显示字幕'.l10n)),
            ],
          ).toSliver(),
          ValueListenableBuilder(
            valueListenable: App().player.subDelay,
            builder: (context, subDelay, _) {
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        App().player.setProperty('sub-delay', '0');
                      });
                    },
                    icon: const Icon(Icons.timer_outlined),
                  ),
                  Expanded(
                    child: Slider(
                      min: -30,
                      max: 30,
                      value: bounded(-30, subDelay, 30),
                      onChanged: (value) {
                        App().player.setProperty('sub-delay', value.toString());
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    alignment: Alignment.center,
                    width: 40,
                    child: FittedBox(
                      child: Text(
                        '${(subDelay >= 0 ? '+' : '')}${subDelay.toStringAsFixed(2)}s',
                      ),
                    ),
                  ),
                ],
              );
            },
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          Text(
            '获取字幕'.l10n,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 14,
            ),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.file_open_outlined),
            label: Text('加载 srt 文件'.l10n),
          ).toSliver(),
          const SizedBox(height: 10).toSliver(),
          // OutlinedButton.icon(
          //   onPressed: null,
          //   icon: const Icon(Icons.wb_cloudy_outlined),
          //   label: Text('在线查找字幕'.l10n),
          // ).toSliver(),
          // const SizedBox(height: 10).toSliver(),
          OutlinedButton.icon(
            onPressed: () {
              _handlePanelSelection(2);
            },
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text('使用 Whisper 生成'.l10n),
          ).toSliver(),
        ]
            .map(
              (v) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: v,
              ),
            )
            .toList(),
      ),
    );
  }
}
