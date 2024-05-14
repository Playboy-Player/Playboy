import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/storage.dart';
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
import 'package:material_symbols_icons/symbols.dart';

import 'file/file_page.dart';

class MikuMiku extends StatelessWidget {
  const MikuMiku({super.key, required this.initMedia});
  final String initMedia;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStorage>(
      builder: (BuildContext context, AppStorage value, Widget? child) {
        MaterialColor themeColor = value.settings.getColorTheme();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Playboy',
          theme: ThemeData(
            fontFamily: "SourceHanSans",
            colorScheme: ColorScheme.fromSeed(
                seedColor: themeColor, brightness: Brightness.light),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            fontFamily: "SourceHanSans",
            colorScheme: ColorScheme.fromSeed(
                seedColor: themeColor, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          themeMode: value.settings.themeMode,
          home: initMedia == '' ? const Home() : const MPlayer(),
        );
      },
    );
  }
}

// TODO: make the media control widget in a new window and support pin on top
// https://docs.google.com/document/d/13E27tD8_9f6lDgwg3MpGNTV8XIRCZH3ByI-t9kI9IUM/edit#heading=h.fygejf72gi1m

// TODO: support drag file to window
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  bool showMediaCard = false;
  bool miniMode = false;

  final playlistPageKey = GlobalKey<NavigatorState>();
  final musicPageKey = GlobalKey<NavigatorState>();
  final videoPageKey = GlobalKey<NavigatorState>();
  final filePageKey = GlobalKey<NavigatorState>();
  final searchPageKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    showMediaCard = AppStorage().settings.showMediaCard;
    currentPageIndex = AppStorage().settings.initPage;
  }

  @override
  Widget build(BuildContext context) {
    // bool tabletUI = MediaQuery.of(context).size.width > 500;
    bool tabletUI = AppStorage().settings.tabletUI;
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.04), colorScheme.surface);
    if (miniMode) {
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
                      ? _buildMediaCardContent(
                          ColorScheme.fromSeed(seedColor: colorScheme.tertiary))
                      : FutureBuilder(
                          future: ColorScheme.fromImageProvider(
                            provider: UniImageProvider(
                                    url: AppStorage().playingCover!)
                                .getImage(),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return _buildMediaCardContent(snapshot.data!);
                            } else {
                              return _buildMediaCardContent(
                                  ColorScheme.fromSeed(
                                      seedColor: colorScheme.tertiary));
                            }
                          },
                        );
                })),
      );
    }
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        flexibleSpace: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            windowManager.startDragging();
          },
        ),
        toolbarHeight: 40,
        title: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              windowManager.startDragging();
            },
            child: Row(children: [
              IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (!context.mounted) return;
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const MPlayer(),
                      ),
                    );
                  },
                  icon: const Icon(Constants.appIcon)),
              const SizedBox(
                width: 10,
              ),
              tabletUI
                  ? StreamBuilder(
                      stream: AppStorage().playboy.stream.playlist,
                      builder: ((context, snapshot) {
                        return Text(
                          AppStorage().playingTitle == 'Not Playing'
                              ? Constants.appName
                              : AppStorage().playingTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }))
                  : const SizedBox(),
            ])),
        actions: [
          IconButton(
              hoverColor: Colors.transparent,
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage()))
                    .then((value) {
                  AppStorage().updateFilePage();
                }).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(
                Symbols.settings_rounded,
                weight: 500,
              )),
          AppStorage().settings.showMediaCard
              ? IconButton(
                  hoverColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      showMediaCard = !showMediaCard;
                    });
                  },
                  icon: const Icon(
                    Symbols.branding_watermark_rounded,
                    weight: 550,
                  ))
              : const SizedBox(),
          IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () {
                windowManager.minimize();
              },
              icon: const Icon(Icons.minimize)),
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
                  selectedIndex: currentPageIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
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
                            iconSize: 28,
                            icon:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Icon(Icons.wb_sunny_outlined)
                                    : const Icon(Icons.mode_night_outlined),
                            onPressed: () {
                              setState(() {
                                AppStorage().settings.themeMode =
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? ThemeMode.light
                                        : ThemeMode.dark;
                              });
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
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      selectedIcon: Icon(Icons.web_stories),
                      icon: Icon(Icons.web_stories_outlined),
                      label: Text('播放列表'),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Icon(Icons.music_note),
                      icon: Icon(Icons.music_note_outlined),
                      label: Text('音乐'),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Icon(Icons.movie_filter),
                      icon: Icon(Icons.movie_filter_outlined),
                      label: Text('视频'),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Icon(Icons.folder),
                      icon: Icon(Icons.folder_outlined),
                      label: Text('文件'),
                    ),
                    NavigationRailDestination(
                      selectedIcon: Icon(Icons.search),
                      icon: Icon(Icons.search),
                      label: Text('搜索'),
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
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const MPlayer(),
                      ),
                    );
                  },
                  child: StreamBuilder(
                      stream: AppStorage().playboy.stream.playlist,
                      builder: (context, snapshot) {
                        return AppStorage().playingCover == null
                            ? _buildMediaBar(ColorScheme.fromSeed(
                                seedColor: colorScheme.tertiary))
                            : FutureBuilder(
                                future: ColorScheme.fromImageProvider(
                                  provider: UniImageProvider(
                                          url: AppStorage().playingCover!)
                                      .getImage(),
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    return _buildMediaBar(snapshot.data!);
                                  } else {
                                    return _buildMediaBar(ColorScheme.fromSeed(
                                        seedColor: colorScheme.tertiary));
                                  }
                                },
                              );
                      }),
                )
              ],
            ),
      floatingActionButton: showMediaCard && tabletUI
          ? InkWell(
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const MPlayer(),
                  ),
                );
              },
              child: StreamBuilder(
                  stream: AppStorage().playboy.stream.playlist,
                  builder: (context, snapshot) {
                    return AppStorage().playingCover == null
                        ? _buildMediaCard(ColorScheme.fromSeed(
                            seedColor: colorScheme.tertiary))
                        : FutureBuilder(
                            future: ColorScheme.fromImageProvider(
                              provider: UniImageProvider(
                                      url: AppStorage().playingCover!)
                                  .getImage(),
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                return _buildMediaCard(snapshot.data!);
                              } else {
                                return _buildMediaCard(ColorScheme.fromSeed(
                                    seedColor: colorScheme.tertiary));
                              }
                            },
                          );
                  }),
            )
          : null,
      bottomNavigationBar: tabletUI
          ? null
          : NavigationBar(
              height: 50,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.web_stories),
                  icon: Icon(Icons.web_stories_outlined),
                  label: '播放列表',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.music_note),
                  icon: Icon(Icons.music_note_outlined),
                  label: '音乐',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.movie_filter),
                  icon: Icon(Icons.movie_filter_outlined),
                  label: '视频',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.folder),
                  icon: Icon(Icons.folder_outlined),
                  label: '文件',
                ),
                NavigationDestination(
                  selectedIcon: Icon(Icons.search),
                  icon: Icon(Icons.search),
                  label: '搜索',
                ),
              ],
            ),
    );
  }

  Widget _buildMediaCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      // color: colorScheme.primary,
      child: SizedBox(
          width: 300, height: 120, child: _buildMediaCardContent(colorScheme)),
    );
  }

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
                          Colors.black.withOpacity(0.6),
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
                            // TODO: show author
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
      index: currentPageIndex,
      children: [
        Navigator(
          key: playlistPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const PlaylistPage(),
          ),
        ),
        Navigator(
          key: musicPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const MusicPage(),
          ),
        ),
        Navigator(
          key: videoPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const VideoPage(),
          ),
        ),
        Navigator(
          key: filePageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const FilePage(),
          ),
        ),
        Navigator(
          key: searchPageKey,
          onGenerateRoute: (route) => MaterialPageRoute(
            settings: route,
            builder: (context) => const SearchPage(),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaCardContent(ColorScheme colorScheme) {
    return Container(
      // color: colorScheme.primary,
      decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(miniMode ? 0 : 20)),
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
                        Colors.black.withOpacity(0.6),
                        // Colors.black.withOpacity(0.1)
                        Colors.transparent
                      ],
                      // stops: [0, 0.6],
                      // tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(miniMode ? 0 : 20),
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.primaryContainer,
                            ),
                            maxLines: 1,
                          ),
                          // TODO: show author
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
                            if (miniMode) {
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
                              miniMode = !miniMode;
                            });
                          },
                          icon: Icon(
                            miniMode ? Icons.fullscreen : Icons.fullscreen_exit,
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
                          )),
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
                                  setState(() {
                                    AppStorage().seeking = true;
                                  });
                                },
                                onChangeEnd: (value) {
                                  AppStorage()
                                      .playboy
                                      .seek(
                                          Duration(milliseconds: value.toInt()))
                                      .then((value) => {
                                            setState(() {
                                              AppStorage().seeking = false;
                                            })
                                          });
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
                          )),
                      IconButton(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        constraints: const BoxConstraints(),
                        color: colorScheme.primaryContainer,
                        onPressed: () {
                          setState(() {
                            AppStorage().shuffle = !AppStorage().shuffle;
                          });
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
                          )),
                      const SizedBox(
                        width: 6,
                      ),
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
