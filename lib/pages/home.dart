import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/pages/media/music_page.dart';
import 'package:playboy/pages/playlist/playlist_page.dart';
import 'package:playboy/pages/search/search_page.dart';
import 'package:playboy/pages/settings/settings_page.dart';
import 'package:playboy/pages/media/video_page.dart';
import 'package:playboy/widgets/uni_image.dart';
import 'package:provider/provider.dart';
import 'package:squiggly_slider/slider.dart';
import 'package:window_manager/window_manager.dart';
import 'file/file_page.dart';

class MikuMiku extends StatelessWidget {
  const MikuMiku({super.key, required this.initMedia});

  final String initMedia;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStorage>(
      builder: (BuildContext context, AppStorage value, Widget? child) {
        MaterialColor themeColor = value.getColorTheme();
        var lightTheme = ColorScheme.fromSeed(
            seedColor: themeColor, brightness: Brightness.light);
        var darkTheme = ColorScheme.fromSeed(
            seedColor: themeColor, brightness: Brightness.dark);
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale(value.settings.language),
          debugShowCheckedModeBanner: false,
          title: 'Playboy',
          theme: ThemeData(
            fontFamily: value.settings.font != '' ? value.settings.font : null,
            fontFamilyFallback: [value.settings.fallbackfont],
            colorScheme: lightTheme,
            tooltipTheme: TooltipThemeData(
              decoration: BoxDecoration(
                color: lightTheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(
                color: lightTheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            dialogTheme: DialogTheme(
              surfaceTintColor: Colors.transparent,
              barrierColor: lightTheme.surfaceTint.withValues(alpha: 0.1),
              shadowColor: Colors.black,
            ),
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: lightTheme.surface,
            ),
            navigationRailTheme: NavigationRailThemeData(
              backgroundColor: Color.alphaBlend(
                lightTheme.primary.withValues(alpha: 0.04),
                lightTheme.surface,
              ),
              indicatorColor: lightTheme.primaryContainer,
            ),
            iconButtonTheme: const IconButtonThemeData(
              style: ButtonStyle(iconSize: WidgetStatePropertyAll(22)),
            ),
          ),
          darkTheme: ThemeData(
            fontFamily: value.settings.font != '' ? value.settings.font : null,
            fontFamilyFallback: [value.settings.fallbackfont],
            colorScheme: darkTheme,
            tooltipTheme: TooltipThemeData(
              decoration: BoxDecoration(
                color: darkTheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: TextStyle(
                color: darkTheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            dialogTheme: DialogTheme(
              surfaceTintColor: Colors.transparent,
              barrierColor: darkTheme.surfaceTint.withValues(alpha: 0.1),
              shadowColor: Colors.black,
            ),
            appBarTheme: AppBarTheme(
              scrolledUnderElevation: 0,
              backgroundColor: darkTheme.surface,
            ),
            navigationRailTheme: NavigationRailThemeData(
              backgroundColor: Color.alphaBlend(
                darkTheme.primary.withValues(alpha: 0.04),
                darkTheme.surface,
              ),
              indicatorColor: darkTheme.primaryContainer,
            ),
            iconButtonTheme: const IconButtonThemeData(
              style: ButtonStyle(iconSize: WidgetStatePropertyAll(22)),
            ),
          ),
          themeMode: value.settings.themeMode,
          home: initMedia == '' ? const Home() : const MPlayer(),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  // bool showMediaCard = false;
  bool _miniMode = false;

  final _playlistPageKey = GlobalKey<NavigatorState>();
  final _musicPageKey = GlobalKey<NavigatorState>();
  final _videoPageKey = GlobalKey<NavigatorState>();
  final _filePageKey = GlobalKey<NavigatorState>();
  final _searchPageKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // showMediaCard = AppStorage().settings.showMediaCard;
    _currentPageIndex = AppStorage().settings.initPage;
  }

  @override
  Widget build(BuildContext context) {
    // bool tabletUI = MediaQuery.of(context).size.width > 500;
    bool tabletUI = AppStorage().settings.tabletUI;
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    if (_miniMode) {
      return Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            windowManager.startDragging();
          },
          child: StreamBuilder(
            stream: AppStorage().playboy.stream.playlist,
            builder: (context, snapshot) {
              return AppStorage().playingCover == null
                  ? _buildMediaCardContent(colorScheme)
                  : FutureBuilder(
                      future: ColorScheme.fromImageProvider(
                        provider:
                            UniImageProvider(url: AppStorage().playingCover!)
                                .getImage(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return _buildMediaCardContent(snapshot.data!);
                        } else {
                          return _buildMediaCardContent(colorScheme);
                        }
                      },
                    );
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
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
        title: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              windowManager.startDragging();
            },
            child: Row(children: [
              Platform.isMacOS
                  ? const SizedBox(width: 60)
                  : IconButton(
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (!context.mounted) return;
                        pushRootPage(
                          context,
                          const MPlayer(),
                        );
                      },
                      icon: const Icon(Constants.appIcon)),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: tabletUI
                    ? StreamBuilder(
                        stream: AppStorage().playboy.stream.playlist,
                        builder: ((context, snapshot) {
                          return Text(
                            AppStorage().playingTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              // fontWeight: FontWeight.w500,
                            ),
                          );
                        }))
                    : const SizedBox(),
              ),
            ])),
        actions: [
          IconButton(
              hoverColor: Colors.transparent,
              onPressed: () {
                // setState(() {
                //   showMediaCard = !showMediaCard;
                // });
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
              )),
          if (Platform.isMacOS)
            IconButton(
              hoverColor: Colors.transparent,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (!context.mounted) return;
                pushRootPage(
                  context,
                  const MPlayer(),
                );
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
                icon: const Icon(Icons.minimize)),
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
                icon: const Icon(Icons.crop_square)),
          if (!Platform.isMacOS)
            IconButton(
                hoverColor: Colors.transparent,
                iconSize: 20,
                onPressed: () {
                  windowManager.close();
                },
                icon: const Icon(Icons.close)),
        ],
      ),
      body: tabletUI
          ? Row(
              children: <Widget>[
                NavigationRail(
                  // groupAlignment: -0.9,
                  backgroundColor: backgroundColor,
                  minWidth: 64,
                  selectedIndex: _currentPageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  // extended: true,
                  // leading: const SizedBox(
                  //   height: 6,
                  // ),
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
                            icon:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Icon(Icons.wb_sunny)
                                    : const Icon(Icons.dark_mode),
                            onPressed: () {
                              setState(
                                () {
                                  AppStorage().settings.themeMode =
                                      Theme.of(context).brightness ==
                                              Brightness.dark
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
                      selectedIcon: const Icon(Icons.web_stories),
                      icon: const Icon(Icons.web_stories_outlined),
                      label: Text(context.l10n.playlist),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.music_note),
                      icon: const Icon(Icons.music_note_outlined),
                      label: Text(context.l10n.music),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.movie_filter),
                      icon: const Icon(Icons.movie_filter_outlined),
                      label: Text(context.l10n.video),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.folder),
                      icon: const Icon(Icons.folder_outlined),
                      label: Text(context.l10n.files),
                    ),
                    NavigationRailDestination(
                      selectedIcon: const Icon(Icons.search),
                      icon: const Icon(Icons.search),
                      label: Text(context.l10n.search),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: backgroundColor,
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      child: _buildContent(),
                    ),
                  ),
                )
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildContent()),
                InkWell(
                  onTap: () {
                    if (!context.mounted) return;
                    pushRootPage(
                      context,
                      const MPlayer(),
                    );
                  },
                  child: StreamBuilder(
                    stream: AppStorage().playboy.stream.playlist,
                    builder: (context, snapshot) {
                      return AppStorage().playingCover == null
                          ? _buildMediaBar(colorScheme)
                          : FutureBuilder(
                              future: ColorScheme.fromImageProvider(
                                provider: UniImageProvider(
                                        url: AppStorage().playingCover!)
                                    .getImage(),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return _buildMediaBar(snapshot.data!);
                                } else {
                                  return _buildMediaBar(colorScheme);
                                }
                              },
                            );
                    },
                  ),
                )
              ],
            ),
      floatingActionButton: StreamBuilder(
        stream: AppStorage().playboy.stream.playlist,
        builder: (context, snapshot) {
          return AppStorage().playingTitle != 'Not Playing' && tabletUI
              ? _buildMediaButtons(colorScheme)
              : const SizedBox();
        },
      ),
      bottomNavigationBar: tabletUI
          ? null
          : NavigationBar(
              height: 70,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              selectedIndex: _currentPageIndex,
              destinations: <Widget>[
                const NavigationDestination(
                  selectedIcon: Icon(Icons.web_stories),
                  icon: Icon(Icons.web_stories_outlined),
                  label: '播放列表',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.music_note),
                  icon: Icon(Icons.music_note_outlined),
                  label: '音乐',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.movie_filter),
                  icon: Icon(Icons.movie_filter_outlined),
                  label: '视频',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.folder),
                  icon: Icon(Icons.folder_outlined),
                  label: '文件',
                ),
                if (AppStorage().settings.tabletUI)
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.search),
                    icon: Icon(Icons.search),
                    label: '搜索',
                  ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.settings),
                  icon: Icon(Icons.settings_outlined),
                  label: '设置',
                ),
              ],
            ),
    );
  }

  // Widget _buildMediaCard(ColorScheme colorScheme) {
  //   return Card(
  //     elevation: 1.6,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //     ),
  //     // color: colorScheme.primary,
  //     child: SizedBox(
  //         width: 300, height: 120, child: _buildMediaCardContent(colorScheme)),
  //   );
  // }

  Widget _buildMediaBar(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: colorScheme.primary,
      ),
      child: SizedBox(
        height: 70,
        child: Stack(
          children: [
            AppStorage().playingCover == null
                ? const SizedBox()
                : ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return RadialGradient(
                        radius: 2,
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
                        borderRadius: BorderRadius.circular(20),
                        child: UniImage(url: AppStorage().playingCover!)),
                  ),
            Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStorage().playingTitle,
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
                            // ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          color: colorScheme.primaryContainer,
                          onPressed: () {
                            AppStorage().playboy.next();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.skip_next_outlined,
                          )),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
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
          key: _musicPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const MusicPage(),
          ),
        ),
        Navigator(
          key: _videoPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const VideoPage(),
          ),
        ),
        Navigator(
          key: _filePageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const FilePage(),
          ),
        ),
        if (AppStorage().settings.tabletUI)
          Navigator(
            key: _searchPageKey,
            onGenerateRoute: (route) => MaterialPageRoute(
              settings: route,
              builder: (context) => const SearchPage(),
            ),
          )
        else
          const SettingsPage(),
      ],
    );
  }

  Widget _buildMediaCardContent(ColorScheme colorScheme) {
    return Container(
      // color: colorScheme.primary,
      decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(_miniMode ? 0 : 20)),
      child: Stack(
        children: [
          AppStorage().playingCover == null
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
                      child: UniImage(url: AppStorage().playingCover!)),
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
                            borderRadius: BorderRadius.circular(16)),
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
                        icon: Icon(
                          _miniMode ? Icons.fullscreen : Icons.fullscreen_exit,
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
                            return SquigglySlider(
                              squiggleAmplitude:
                                  AppStorage().settings.wavySlider ? 1.4 : 0,
                              squiggleWavelength: 4,
                              squiggleSpeed: 0.05,
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
                        AppStorage().closeMedia();
                        setState(() {});
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

  Widget _buildMediaButtons(ColorScheme colorScheme) {
    return Container(
      width: 360,
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
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
              setState(() {
                AppStorage().playboy.playOrPause();
              });
            },
            icon: StreamBuilder(
              stream: AppStorage().playboy.stream.playing,
              builder: (context, snapshot) {
                return Icon(
                  AppStorage().playing ? Icons.pause : Icons.play_arrow,
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
              Icons.skip_previous,
              // size: 30,
            ),
          ),
          Expanded(
            // width: 120,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: SliderComponentShape.noOverlay,
                thumbColor: colorScheme.primaryContainer,
                activeTrackColor: colorScheme.primaryContainer,
              ),
              child: StreamBuilder(
                stream: AppStorage().playboy.stream.position,
                builder: (context, snapshot) {
                  return SquigglySlider(
                    squiggleAmplitude:
                        AppStorage().settings.wavySlider ? 1.4 : 0,
                    squiggleWavelength: 4,
                    squiggleSpeed: 0.05,
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
                AppStorage().playboy.setPlaylistMode(PlaylistMode.none);
              } else {
                AppStorage().playboy.setPlaylistMode(PlaylistMode.single);
              }
              setState(() {});
            },
            icon: AppStorage().playboy.state.playlistMode == PlaylistMode.single
                ? const Icon(Icons.repeat_one_on)
                : const Icon(Icons.repeat_one),
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
            icon: const Icon(
              Icons.stop,
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
    );
  }
}
