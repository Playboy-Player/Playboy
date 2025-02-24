import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/widgets/menu/menu_button.dart';
import 'package:playboy/widgets/menu/menu_item.dart';
import 'package:window_manager/window_manager.dart';

import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/pages/media/player_page.dart';
import 'package:playboy/pages/playlist/playlist_page.dart';
import 'package:playboy/pages/search/search_page.dart';
import 'package:playboy/pages/settings/settings_page.dart';
import 'package:playboy/pages/file/file_page.dart';
import 'package:playboy/pages/library/library_page.dart';
import 'package:playboy/widgets/image.dart';

class NoOpIntent extends Intent {
  const NoOpIntent();
}

class NoOpAction extends Action<NoOpIntent> {
  @override
  void invoke(NoOpIntent intent) {
    // do nothing
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.playerView = false,
  });

  final bool playerView;
  static void Function()? refresh;
  static void Function()? switchView;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  int _prePageIndex = 0;
  bool _forceRebuild = false;
  bool _playerView = false;

  bool _fullScreen = false;
  bool _showTitleBarFullscreen = false;

  bool _miniMode = false;

  final _playlistPageKey = GlobalKey<NavigatorState>();
  final _videoPageKey = GlobalKey<NavigatorState>();
  final _filePageKey = GlobalKey<NavigatorState>();
  final _searchPageKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _playerView = widget.playerView;
    _prePageIndex = _currentPageIndex = App().settings.initPage;
    if (_playerView) _currentPageIndex = 4;

    HomePage.refresh = () => setState(() => _forceRebuild = true);
    HomePage.switchView = () => setState(
          () {
            if (_currentPageIndex == 4) {
              _currentPageIndex = _prePageIndex;
            } else {
              _prePageIndex = _currentPageIndex;
              _currentPageIndex = 4;
            }
            _playerView = !_playerView;
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_forceRebuild) {
      _forceRebuild = false;
      void rebuild(Element e) {
        e.markNeedsBuild();
        e.visitChildren(rebuild);
      }

      (context as Element).visitChildren(rebuild);
    }

    MaterialColor themeColor = App().getColorTheme();
    var lightTheme = ColorScheme.fromSeed(
      seedColor: themeColor,
      brightness: Brightness.light,
    );
    var darkTheme = ColorScheme.fromSeed(
      seedColor: themeColor,
      brightness: Brightness.dark,
    );
    return MaterialApp(
      shortcuts: {
        // override the default behavior of arrow and space key
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): const NoOpIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): const NoOpIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): const NoOpIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): const NoOpIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): const NoOpIntent(),
      },
      actions: {
        // bind Intent to NoOpAction
        NoOpIntent: NoOpAction(),
      },
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: _getThemeData(App(), lightTheme),
      darkTheme: _getThemeData(App(), darkTheme),
      themeMode: App().settings.themeMode,
      home: Builder(
        builder: (context) {
          if (_miniMode) {
            return _buildMiniModeCard(context);
          }
          return Scaffold(
            appBar: _fullScreen ? null : _buildTitleBar(context),
            body: Stack(
              children: [
                Row(
                  children: [
                    _buildNavigationRail(context),
                    _buildPage(context),
                  ],
                ),
                if (_fullScreen)
                  SizedBox(
                    height: 40,
                    child: AnimatedOpacity(
                      opacity: _showTitleBarFullscreen ? 1 : 0,
                      duration: const Duration(milliseconds: 100),
                      child: MouseRegion(
                        onHover: (event) {
                          setState(() {
                            _showTitleBarFullscreen = true;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            _showTitleBarFullscreen = false;
                          });
                        },
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: _buildTitleBar(context),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: _playerView
                ? const SizedBox()
                : _buildFloatingMediaBar(context),
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(App value, ColorScheme colorScheme) {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
      fontFamily: value.settings.font != '' ? value.settings.font : null,
      fontFamilyFallback: Platform.isWindows ? ['Microsoft YaHei UI'] : null,
      colorScheme: colorScheme,
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: TextStyle(
          color: colorScheme.onSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: colorScheme.surfaceTint.withValues(alpha: 0.1),
        shadowColor: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Color.alphaBlend(
          colorScheme.primary.withValues(alpha: 0.04),
          colorScheme.surface,
        ),
        indicatorColor: colorScheme.primaryContainer,
      ),
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconSize: WidgetStatePropertyAll(22),
        ),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        year2023: false,
        trackHeight: 4,
        thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
        overlayShape: SliderComponentShape.noOverlay,
      ),
    );
  }

  PreferredSizeWidget _buildTitleBar(BuildContext context) {
    // bool tabletUI = MediaQuery.of(context).size.width > 500;
    bool tabletUI = App().settings.tabletUI;
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      flexibleSpace: Column(
        children: [
          SizedBox(
            height: 8,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUp,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) {
                  if (!_fullScreen) {
                    windowManager.startResizing(ResizeEdge.top);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                if (!_fullScreen) {
                  windowManager.startDragging();
                }
              },
            ),
          )
        ],
      ),
      toolbarHeight: 40,
      titleSpacing: 8,
      title: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          if (!_fullScreen) {
            windowManager.startDragging();
          }
        },
        child: Row(
          children: [
            IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  colorScheme.primaryContainer.withValues(alpha: 0.4),
                ),
                foregroundColor: WidgetStatePropertyAll(
                  colorScheme.primary,
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 17, vertical: 2),
                ),
              ),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () {
                HomePage.switchView?.call();
              },
              icon: const Icon(Icons.play_circle_outline_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: tabletUI
                  ? StreamBuilder(
                      stream: App().playboy.stream.playlist,
                      builder: (context, snapshot) {
                        return Text(
                          App().playingTitle,
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      actions: _buildTitleBarActions(context),
    );
  }

  List<Widget> _buildTitleBarActions(BuildContext context) {
    return [
      if (!_fullScreen)
        MenuButton(
          menuChildren: [
            const SizedBox(height: 10),
            MMenuItem(
              icon: Icons.open_in_full,
              label: '全屏模式',
              onPressed: () async {
                if (_fullScreen) {
                  windowManager.setFullScreen(false);
                } else {
                  windowManager.setFullScreen(true);
                }
                setState(() {
                  _fullScreen = !_fullScreen;
                  _showTitleBarFullscreen = false;
                });
              },
            ),
            MMenuItem(
              icon: Icons.music_note_outlined,
              label: '迷你音乐播放器',
              onPressed: () {
                windowManager.setResizable(false);
                windowManager.setMinimumSize(const Size(300, 120));
                windowManager.setSize(const Size(300, 120));
                windowManager.setAlwaysOnTop(true);
                setState(() {
                  _miniMode = !_miniMode;
                });
              },
            ),
            const MMenuItem(
              icon: Icons.picture_in_picture,
              label: '画中画',
              onPressed: null,
            ),
            const MMenuItem(
              icon: Icons.push_pin_outlined,
              label: '应用置顶',
              onPressed: null,
            ),
            const Divider(),
            const MMenuItem(
              icon: Icons.info_outline,
              label: '关于应用',
              onPressed: null,
            ),
            const MMenuItem(
              icon: Icons.upcoming_outlined,
              label: '检查更新',
              onPressed: null,
            ),
            const SizedBox(height: 10),
          ],
        ),
      const SizedBox(width: 10),
      if (!_fullScreen)
        IconButton(
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          iconSize: 26,
          onPressed: () {
            windowManager.minimize();
          },
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      if (!_fullScreen)
        IconButton(
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          iconSize: 26,
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
          icon: const Icon(Icons.keyboard_arrow_up),
        ),
      if (_fullScreen)
        IconButton(
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          iconSize: 26,
          onPressed: () async {
            if (_fullScreen) {
              windowManager.setFullScreen(false);
            } else {
              windowManager.setFullScreen(true);
            }
            setState(() {
              _fullScreen = !_fullScreen;
              _showTitleBarFullscreen = false;
            });
          },
          icon: const Icon(Icons.fullscreen_exit),
        ),
      IconButton(
        hoverColor: Colors.transparent,
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: () {
          windowManager.close();
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  Widget _buildMiniModeCard(BuildContext context) {
    Widget buildMediaCardContent(ColorScheme colorScheme) {
      return Container(
        // color: colorScheme.primary,
        decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(_miniMode ? 0 : 20)),
        child: Stack(
          children: [
            App().playingCover == null ||
                    !File(App().playingCover!).existsSync()
                ? const SizedBox()
                : ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        radius: 1.4,
                        // focalRadius: 1,
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          // Colors.black.withOpacity(0.1)
                          Colors.transparent
                        ],
                        // stops: [0, 0.6],
                        // tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_miniMode ? 0 : 20),
                      child: MImage(url: App().playingCover!),
                    ),
                  ),
            Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              App().playingTitle,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.primaryContainer,
                              ),
                              maxLines: 1,
                            ),
                            // Text(
                            //   'author',
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     color: colorScheme.primaryContainer,
                            //   ),
                            // )
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        iconSize: 24,
                        onPressed: () {
                          setState(() {
                            App().playboy.playOrPause();
                          });
                        },
                        icon: StreamBuilder(
                          stream: App().playboy.stream.playing,
                          builder: (context, snapshot) {
                            return Icon(
                              App().playing
                                  ? Icons.pause_circle_outline
                                  : Icons.play_arrow_outlined,
                              color: colorScheme.onPrimaryContainer,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        // iconSize: 30,
                        onPressed: () {
                          // exit mini mode
                          windowManager.setResizable(true);
                          windowManager.setMinimumSize(const Size(360, 500));
                          windowManager.setSize(const Size(900, 700));
                          windowManager.setAlwaysOnTop(false);
                          windowManager.center();
                          setState(() {
                            _miniMode = !_miniMode;
                          });
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        // iconSize: 30,
                        onPressed: () {
                          App().playboy.previous();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          // size: 30,
                        ),
                      ),
                      Expanded(
                        // width: 120,
                        child: SliderTheme(
                          data: SliderThemeData(
                            year2023: false,
                            trackHeight: 3,
                            thumbSize:
                                const WidgetStatePropertyAll(Size(4, 14)),
                            // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                            overlayShape: SliderComponentShape.noOverlay,
                            thumbColor: colorScheme.primaryContainer,
                            activeTrackColor: colorScheme.primaryContainer,
                          ),
                          child: StreamBuilder(
                            stream: App().playboy.stream.position,
                            builder: (context, snapshot) {
                              return Slider(
                                max: App().duration.inMilliseconds.toDouble(),
                                value: App().seeking
                                    ? App().seekingPos
                                    : min(
                                        snapshot.hasData
                                            ? snapshot.data!.inMilliseconds
                                                .toDouble()
                                            : App()
                                                .position
                                                .inMilliseconds
                                                .toDouble(),
                                        App()
                                            .duration
                                            .inMilliseconds
                                            .toDouble()),
                                onChanged: (value) {
                                  setState(() {
                                    App().seekingPos = value;
                                  });
                                },
                                onChangeStart: (value) {
                                  setState(
                                    () {
                                      App().seeking = true;
                                    },
                                  );
                                },
                                onChangeEnd: (value) {
                                  App()
                                      .playboy
                                      .seek(
                                          Duration(milliseconds: value.toInt()))
                                      .then(
                                        (value) => {
                                          setState(
                                            () {
                                              App().seeking = false;
                                            },
                                          )
                                        },
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          App().playboy.next();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          setState(
                            () {
                              App().shuffle = !App().shuffle;
                            },
                          );
                        },
                        icon: App().shuffle
                            ? const Icon(Icons.shuffle_on_rounded)
                            : const Icon(Icons.shuffle_rounded),
                        iconSize: 20,
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          if (App().playboy.state.playlistMode ==
                              PlaylistMode.single) {
                            App().playboy.setPlaylistMode(PlaylistMode.none);
                          } else {
                            App().playboy.setPlaylistMode(PlaylistMode.single);
                          }
                          setState(() {});
                        },
                        icon: App().playboy.state.playlistMode ==
                                PlaylistMode.single
                            ? const Icon(Icons.repeat_one_on_rounded)
                            : const Icon(Icons.repeat_one_rounded),
                        iconSize: 20,
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          App().closeMedia().then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(
                          Icons.stop_rounded,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    late final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          windowManager.startDragging();
        },
        child: StreamBuilder(
          stream: App().playboy.stream.playlist,
          builder: (context, snapshot) {
            return App().playingCover == null ||
                    !File(App().playingCover!).existsSync()
                ? buildMediaCardContent(colorScheme)
                : FutureBuilder(
                    future: ColorScheme.fromImageProvider(
                      provider: MImageProvider(
                        url: App().playingCover!,
                      ).getImage(),
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return buildMediaCardContent(snapshot.data!);
                      } else {
                        return buildMediaCardContent(colorScheme);
                      }
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    return _playerView
        ? Container(
            width: _fullScreen ? 0 : 10,
            color: backgroundColor,
          )
        : NavigationRail(
            backgroundColor: backgroundColor,
            minWidth: 64,
            selectedIndex: _currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentPageIndex = index;
                _prePageIndex = _currentPageIndex;
              });
            },
            labelType: NavigationRailLabelType.selected,
            trailing: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 24,
                      icon: const Icon(
                        Icons.filter_vintage,
                      ),
                      onPressed: () {
                        pushPage(
                          context,
                          const SettingsPage(),
                        ).then((value) {
                          App().updateFilePage();
                          setState(() {});
                        });
                      },
                    ),
                    const SizedBox(height: 6),
                    IconButton(
                      iconSize: 24,
                      icon: Theme.of(context).brightness == Brightness.dark
                          ? const Icon(Icons.wb_sunny)
                          : const Icon(Icons.dark_mode),
                      onPressed: () {
                        setState(
                          () {
                            App().settings.themeMode =
                                Theme.of(context).brightness == Brightness.dark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                          },
                        );
                        App().saveSettings();
                      },
                    ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                ),
              ),
            ),
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                selectedIcon: const Icon(Icons.apps),
                icon: const Icon(Icons.apps),
                label: Text('播放列表'.l10n),
              ),
              NavigationRailDestination(
                selectedIcon: const Icon(Icons.smart_display),
                icon: const Icon(Icons.smart_display_outlined),
                label: Text('媒体库'.l10n),
              ),
              NavigationRailDestination(
                selectedIcon: const Icon(Icons.folder),
                icon: const Icon(Icons.folder_outlined),
                label: Text('文件'.l10n),
              ),
              NavigationRailDestination(
                selectedIcon: const Icon(Icons.search),
                icon: const Icon(Icons.search),
                label: Text('搜索'.l10n),
              ),
            ],
          );
  }

  Widget _buildPage(BuildContext context) {
    Widget buildPageContent(BuildContext context) {
      return IndexedStack(
        index: _currentPageIndex,
        children: [
          Navigator(
            key: _playlistPageKey,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const PlaylistPage(),
            ),
          ),
          Navigator(
            key: _videoPageKey,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const LibraryPage(),
            ),
          ),
          Navigator(
            key: _filePageKey,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const FilePage(),
            ),
          ),
          Navigator(
            key: _searchPageKey,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const SearchPage(),
            ),
          ),
          PlayerPage(fullscreen: _fullScreen),
        ],
      );
    }

    if (_fullScreen) {
      return Expanded(
        child: buildPageContent(context),
      );
    }

    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    return Expanded(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
          child: buildPageContent(context),
        ),
      ),
    );
  }

  Widget _buildFloatingMediaBar(BuildContext context) {
    Widget buildFloatingMediaBarContent(BuildContext context) {
      late final colorScheme = Theme.of(context).colorScheme;
      return Container(
        width: 360,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 10),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              // iconSize: 30,
              onPressed: () {
                setState(() {
                  App().playboy.playOrPause();
                });
              },
              icon: StreamBuilder(
                stream: App().playboy.stream.playing,
                builder: (context, snapshot) {
                  return Icon(
                    App().playing
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  );
                },
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              // iconSize: 30,
              onPressed: () {
                App().playboy.previous();
                setState(() {});
              },
              icon: const Icon(
                Icons.skip_previous_rounded,
                // size: 30,
              ),
            ),
            Expanded(
              // width: 120,
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: colorScheme.primaryContainer,
                  activeTrackColor: colorScheme.primaryContainer,
                  year2023: false,
                  trackHeight: 4,
                  thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
                  // thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: StreamBuilder(
                  stream: App().playboy.stream.position,
                  builder: (context, snapshot) {
                    return Slider(
                      max: App().duration.inMilliseconds.toDouble(),
                      value: App().seeking
                          ? App().seekingPos
                          : max(
                              min(
                                  snapshot.hasData
                                      ? snapshot.data!.inMilliseconds.toDouble()
                                      : App()
                                          .position
                                          .inMilliseconds
                                          .toDouble(),
                                  App().duration.inMilliseconds.toDouble()),
                              0),
                      onChanged: (value) {
                        setState(
                          () {
                            App().seekingPos = value;
                          },
                        );
                      },
                      onChangeStart: (value) {
                        setState(
                          () {
                            App().seeking = true;
                          },
                        );
                      },
                      onChangeEnd: (value) {
                        App()
                            .playboy
                            .seek(Duration(milliseconds: value.toInt()))
                            .then(
                              (value) => {
                                setState(
                                  () {
                                    App().seeking = false;
                                  },
                                )
                              },
                            );
                      },
                    );
                  },
                ),
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              onPressed: () {
                App().playboy.next();
                setState(() {});
              },
              icon: const Icon(
                Icons.skip_next_rounded,
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              onPressed: () {
                setState(
                  () {
                    App().shuffle = !App().shuffle;
                  },
                );
              },
              icon: App().shuffle
                  ? const Icon(Icons.shuffle_on_rounded)
                  : const Icon(Icons.shuffle_rounded),
              iconSize: 20,
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
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
              iconSize: 20,
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              onPressed: () {
                App().closeMedia();
                setState(() {});
              },
              icon: const Icon(Icons.stop_rounded),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );
    }

    // late final colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder(
      stream: App().playboy.stream.playlist,
      builder: (context, snapshot) {
        return App().playingTitle != 'Not Playing' && App().settings.tabletUI
            ? buildFloatingMediaBarContent(context)
            : const SizedBox();
      },
    );
  }
}
