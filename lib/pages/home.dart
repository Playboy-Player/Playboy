import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/storage.dart';
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

  bool _miniMode = false;

  final _playlistPageKey = GlobalKey<NavigatorState>();
  final _videoPageKey = GlobalKey<NavigatorState>();
  final _filePageKey = GlobalKey<NavigatorState>();
  final _searchPageKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _playerView = widget.playerView;
    _prePageIndex = _currentPageIndex = AppStorage().settings.initPage;

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

    MaterialColor themeColor = AppStorage().getColorTheme();
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
      theme: _getThemeData(AppStorage(), lightTheme),
      darkTheme: _getThemeData(AppStorage(), darkTheme),
      themeMode: AppStorage().settings.themeMode,
      home: Builder(
        builder: (context) {
          if (_miniMode) {
            return _buildMiniModeCard(context);
          }
          return Scaffold(
            appBar: _buildTitleBar(context),
            // body: AnimatedCrossSlide(
            //   firstChild: Row(
            //     children: [
            //       _buildNavigationRail(context),
            //       _buildPage(context),
            //     ],
            //   ),
            //   secondChild: const PlayerPage(),
            //   crossFadeState: _playerView
            //       ? CrossFadeState.showFirst
            //       : CrossFadeState.showSecond,
            //   duration: const Duration(
            //     milliseconds: 200,
            //   ),
            // ),

            body: Row(
              children: [
                _buildNavigationRail(context),
                _buildPage(context),
              ],
            ),
            floatingActionButton:
                _playerView ? null : _buildFloatingMediaBar(context),
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(AppStorage value, ColorScheme colorScheme) {
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
    );
  }

  PreferredSizeWidget _buildTitleBar(BuildContext context) {
    // bool tabletUI = MediaQuery.of(context).size.width > 500;
    bool tabletUI = AppStorage().settings.tabletUI;
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
                  windowManager.startResizing(ResizeEdge.top);
                },
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (details) {
                windowManager.startDragging();
              },
            ),
          )
        ],
      ),
      toolbarHeight: 40,
      titleSpacing: Platform.isMacOS ? null : 8,
      title: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          windowManager.startDragging();
        },
        child: Row(
          children: [
            Platform.isMacOS
                ? Container(width: 60)
                : IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        colorScheme.tertiaryContainer,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        colorScheme.onTertiaryContainer,
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
            const SizedBox(width: 10),
            Expanded(
              child: tabletUI
                  ? StreamBuilder(
                      stream: AppStorage().playboy.stream.playlist,
                      builder: (context, snapshot) {
                        return Text(
                          AppStorage().playingTitle,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
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
      // debug usage
      // IconButton(
      //   hoverColor: Colors.transparent,
      //   padding: EdgeInsets.zero,
      //   onPressed: () {
      //     setState(() {});
      //   },
      //   icon: const Icon(Icons.refresh),
      // ),
      IconButton(
        hoverColor: Colors.transparent,
        onPressed: () {
          if (_miniMode) {
            windowManager.setResizable(true);
            windowManager.setMinimumSize(const Size(360, 500));
            windowManager.setSize(const Size(900, 700));
            windowManager.setAlwaysOnTop(false);
            windowManager.center();
          } else {
            windowManager.setResizable(false);
            windowManager.setMinimumSize(const Size(300, 120));
            windowManager.setSize(const Size(300, 120));
            windowManager.setAlwaysOnTop(true);
          }
          setState(() {
            _miniMode = !_miniMode;
          });
        },
        icon: const Icon(
          Icons.headset_outlined,
        ),
      ),
      if (Platform.isMacOS)
        IconButton(
          hoverColor: Colors.transparent,
          padding: EdgeInsets.zero,
          onPressed: () {
            HomePage.switchView?.call();
          },
          icon: const Icon(Icons.play_circle_outlined),
        ),
      const SizedBox(width: 10),
      if (!Platform.isMacOS)
        IconButton(
          hoverColor: Colors.transparent,
          iconSize: 20,
          onPressed: () {
            windowManager.minimize();
          },
          icon: const Icon(Icons.minimize),
        ),
      if (!Platform.isMacOS)
        IconButton(
          hoverColor: Colors.transparent,
          iconSize: 20,
          onPressed: () async {
            if (await windowManager.isMaximized()) {
              windowManager.unmaximize();
            } else {
              windowManager.maximize();
            }
          },
          icon: const Icon(Icons.crop_square),
        ),
      if (!Platform.isMacOS)
        IconButton(
          hoverColor: Colors.transparent,
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
            AppStorage().playingCover == null ||
                    !File(AppStorage().playingCover!).existsSync()
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
                      child: MImage(url: AppStorage().playingCover!),
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
                              AppStorage().playingTitle,
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
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        iconSize: 24,
                        onPressed: () {
                          setState(() {
                            AppStorage().playboy.playOrPause();
                          });
                        },
                        icon: StreamBuilder(
                          stream: AppStorage().playboy.stream.playing,
                          builder: (context, snapshot) {
                            return Icon(
                              AppStorage().playing
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
                        width: 6,
                      ),
                      IconButton(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          constraints: const BoxConstraints(),
                          color: colorScheme.primaryContainer,
                          // iconSize: 30,
                          onPressed: () {
                            if (_miniMode) {
                              windowManager.setResizable(true);
                              windowManager
                                  .setMinimumSize(const Size(360, 500));
                              windowManager.setSize(const Size(900, 700));
                              windowManager.setAlwaysOnTop(false);
                              windowManager.center();
                            } else {
                              windowManager.setResizable(false);
                              windowManager
                                  .setMinimumSize(const Size(300, 120));
                              windowManager.setSize(const Size(300, 120));
                              windowManager.setAlwaysOnTop(true);
                            }
                            setState(() {
                              _miniMode = !_miniMode;
                            });
                          },
                          icon: Icon(
                            _miniMode
                                ? Icons.fullscreen
                                : Icons.fullscreen_exit,
                            // size: 30,
                          )),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        // iconSize: 30,
                        onPressed: () {
                          AppStorage().playboy.previous();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          // size: 30,
                        ),
                      ),
                      Expanded(
                        // width: 120,
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 6),
                            overlayShape: SliderComponentShape.noOverlay,
                            thumbColor: colorScheme.primaryContainer,
                            activeTrackColor: colorScheme.primaryContainer,
                          ),
                          child: StreamBuilder(
                            stream: AppStorage().playboy.stream.position,
                            builder: (context, snapshot) {
                              return Slider(
                                max: AppStorage()
                                    .duration
                                    .inMilliseconds
                                    .toDouble(),
                                value: AppStorage().seeking
                                    ? AppStorage().seekingPos
                                    : min(
                                        snapshot.hasData
                                            ? snapshot.data!.inMilliseconds
                                                .toDouble()
                                            : AppStorage()
                                                .position
                                                .inMilliseconds
                                                .toDouble(),
                                        AppStorage()
                                            .duration
                                            .inMilliseconds
                                            .toDouble()),
                                onChanged: (value) {
                                  setState(() {
                                    AppStorage().seekingPos = value;
                                  });
                                },
                                onChangeStart: (value) {
                                  setState(
                                    () {
                                      AppStorage().seeking = true;
                                    },
                                  );
                                },
                                onChangeEnd: (value) {
                                  AppStorage()
                                      .playboy
                                      .seek(
                                          Duration(milliseconds: value.toInt()))
                                      .then(
                                        (value) => {
                                          setState(
                                            () {
                                              AppStorage().seeking = false;
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
                          AppStorage().playboy.next();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.skip_next,
                        ),
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          setState(
                            () {
                              AppStorage().shuffle = !AppStorage().shuffle;
                            },
                          );
                        },
                        icon: AppStorage().shuffle
                            ? const Icon(Icons.shuffle_on)
                            : const Icon(Icons.shuffle),
                        iconSize: 20,
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          if (AppStorage().playboy.state.playlistMode ==
                              PlaylistMode.single) {
                            AppStorage()
                                .playboy
                                .setPlaylistMode(PlaylistMode.none);
                          } else {
                            AppStorage()
                                .playboy
                                .setPlaylistMode(PlaylistMode.single);
                          }
                          setState(() {});
                        },
                        icon: AppStorage().playboy.state.playlistMode ==
                                PlaylistMode.single
                            ? const Icon(Icons.repeat_one_on)
                            : const Icon(Icons.repeat_one),
                        iconSize: 20,
                      ),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          AppStorage().closeMedia().then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(
                          Icons.stop,
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
          stream: AppStorage().playboy.stream.playlist,
          builder: (context, snapshot) {
            return AppStorage().playingCover == null ||
                    !File(AppStorage().playingCover!).existsSync()
                ? buildMediaCardContent(colorScheme)
                : FutureBuilder(
                    future: ColorScheme.fromImageProvider(
                      provider: MImageProvider(
                        url: AppStorage().playingCover!,
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
            width: 10,
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
                          AppStorage().updateFilePage();
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
                            AppStorage().settings.themeMode =
                                Theme.of(context).brightness == Brightness.dark
                                    ? ThemeMode.light
                                    : ThemeMode.dark;
                          },
                        );
                        AppStorage().saveSettings();
                        AppStorage().updateStatus();
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
          Navigator(
            key: GlobalKey<NavigatorState>(),
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const PlayerPage(),
            ),
          )
        ],
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
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
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
                  AppStorage().playboy.playOrPause();
                });
              },
              icon: StreamBuilder(
                stream: AppStorage().playboy.stream.playing,
                builder: (context, snapshot) {
                  return Icon(
                    AppStorage().playing
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
                AppStorage().playboy.previous();
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
                  trackHeight: 2,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbColor: colorScheme.primaryContainer,
                  activeTrackColor: colorScheme.primaryContainer,
                ),
                child: StreamBuilder(
                  stream: AppStorage().playboy.stream.position,
                  builder: (context, snapshot) {
                    return Slider(
                      max: AppStorage().duration.inMilliseconds.toDouble(),
                      value: AppStorage().seeking
                          ? AppStorage().seekingPos
                          : max(
                              min(
                                  snapshot.hasData
                                      ? snapshot.data!.inMilliseconds.toDouble()
                                      : AppStorage()
                                          .position
                                          .inMilliseconds
                                          .toDouble(),
                                  AppStorage()
                                      .duration
                                      .inMilliseconds
                                      .toDouble()),
                              0),
                      onChanged: (value) {
                        setState(
                          () {
                            AppStorage().seekingPos = value;
                          },
                        );
                      },
                      onChangeStart: (value) {
                        setState(
                          () {
                            AppStorage().seeking = true;
                          },
                        );
                      },
                      onChangeEnd: (value) {
                        AppStorage()
                            .playboy
                            .seek(Duration(milliseconds: value.toInt()))
                            .then(
                              (value) => {
                                setState(
                                  () {
                                    AppStorage().seeking = false;
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
                AppStorage().playboy.next();
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
                    AppStorage().shuffle = !AppStorage().shuffle;
                  },
                );
              },
              icon: AppStorage().shuffle
                  ? const Icon(Icons.shuffle_on_rounded)
                  : const Icon(Icons.shuffle_rounded),
              iconSize: 20,
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              onPressed: () {
                if (AppStorage().playboy.state.playlistMode ==
                    PlaylistMode.single) {
                  AppStorage().playboy.setPlaylistMode(PlaylistMode.none);
                } else {
                  AppStorage().playboy.setPlaylistMode(PlaylistMode.single);
                }
                setState(() {});
              },
              icon:
                  AppStorage().playboy.state.playlistMode == PlaylistMode.single
                      ? const Icon(Icons.repeat_one_on_rounded)
                      : const Icon(Icons.repeat_one_rounded),
              iconSize: 20,
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              constraints: const BoxConstraints(),
              color: colorScheme.primaryContainer,
              onPressed: () {
                AppStorage().closeMedia();
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
      stream: AppStorage().playboy.stream.playlist,
      builder: (context, snapshot) {
        return AppStorage().playingTitle != 'Not Playing' &&
                AppStorage().settings.tabletUI
            ? buildFloatingMediaBarContent(context)
            : const SizedBox();
      },
    );
  }
}
