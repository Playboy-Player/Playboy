import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/models/playitem.dart';
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
  const MikuMiku({super.key});

  @override
  Widget build(BuildContext context) {
    int mk = 1;
    return Consumer<AppStorage>(
      builder: (BuildContext context, AppStorage value, Widget? child) {
        MaterialColor themeColor = value.settings.getColorTheme();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Playboy',
          theme: ThemeData(
            fontFamily: "SourceHanSans",
            // brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
                seedColor: themeColor, brightness: Brightness.light),
            useMaterial3: true,
            // scaffoldBackgroundColor:
            //     AppStorage().settings.enableBackgroundColor
            //         ? themeColor.shade50
            //         : null,
            // appBarTheme: AppStorage().settings.enableBackgroundColor
            //     ? AppBarTheme(backgroundColor: themeColor.shade50)
            //     : null,
          ),
          darkTheme: ThemeData(
            fontFamily: "SourceHanSans",
            // brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
                seedColor: themeColor, brightness: Brightness.dark),
            useMaterial3: true,
          ),
          themeMode: value.settings.themeMode,
          home: Home(
            mk: mk,
          ),
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.mk});
  final int mk;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  //更新页面用标记
  // int mark = 0;
  bool showMediaCard = true;

  @override
  Widget build(BuildContext context) {
    bool tabletUI = MediaQuery.of(context).size.width > 500;
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.08), colorScheme.surface);
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
            child: const Row(children: [
              Icon(Symbols.flutter_rounded),
              SizedBox(
                width: 6,
              ),
              Text(
                'Playboy Preview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )
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
                  setState(() {
                    // mk = mk + 1;
                  });
                });
              },
              icon: const Icon(
                Symbols.settings_rounded,
                weight: 500,
              )),
          IconButton(
              hoverColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  showMediaCard = !showMediaCard;
                });
              },
              icon: const Icon(
                Symbols.smart_button_rounded,
                weight: 500,
              )),
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
                      // child: [
                      //   const PlaylistPage(),
                      //   const MusicPage(),
                      //   const VideoPage(),
                      //   const FilePage(),
                      //   const SearchPage()
                      // ][currentPageIndex],
                      child: IndexedStack(
                        index: currentPageIndex,
                        children: [
                          Navigator(
                            key: AppStorage().playlistPage,
                            onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => const PlaylistPage(),
                            ),
                          ),
                          Navigator(
                            key: AppStorage().musicPage,
                            onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => const MusicPage(),
                            ),
                          ),
                          Navigator(
                            key: AppStorage().videoPage,
                            onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => const VideoPage(),
                            ),
                          ),
                          Navigator(
                            key: AppStorage().filePage,
                            onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => FilePage(mark: widget.mk),
                            ),
                          ),
                          Navigator(
                            key: AppStorage().searchPage,
                            onGenerateRoute: (route) => MaterialPageRoute(
                              settings: route,
                              builder: (context) => const SearchPage(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : Scaffold(
              // body: [
              //   const PlaylistPage(),
              //   const MusicPage(),
              //   const VideoPage(),
              //   const FilePage(),
              //   const SearchPage(),
              // ][currentPageIndex],
              body: IndexedStack(
                index: currentPageIndex,
                children: [
                  Navigator(
                    key: AppStorage().playlistPage,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const PlaylistPage(),
                    ),
                  ),
                  Navigator(
                    key: AppStorage().musicPage,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const MusicPage(),
                    ),
                  ),
                  Navigator(
                    key: AppStorage().videoPage,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const VideoPage(),
                    ),
                  ),
                  Navigator(
                    key: AppStorage().filePage,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => FilePage(mark: widget.mk),
                    ),
                  ),
                  Navigator(
                    key: AppStorage().searchPage,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => const SearchPage(),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: NavigationBar(
                height: 64,
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
            ),
      // TODO: global control
      floatingActionButton: tabletUI
          ? showMediaCard
              ? AppStorage().playingCover == null
                  ? _buildMediaCard(colorScheme)
                  : FutureBuilder(
                      future: ColorScheme.fromImageProvider(
                        provider:
                            UniImageProvider(url: AppStorage().playingCover!)
                                .getImage(),
                      ),
                      builder: (BuildContext context,
                          AsyncSnapshot<ColorScheme> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return InkWell(
                            onTap: () {
                              if (!context.mounted) return;
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => MPlayer(
                                    info: PlayItem(
                                        source: '', cover: null, title: ''),
                                    currentMedia: true,
                                  ),
                                ),
                              );
                            },
                            child: _buildMediaCard(snapshot.data!),
                          );
                        } else {
                          return _buildMediaCard(colorScheme);
                        }
                      },
                    )
              : null
          : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildMediaCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1.6,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      color: colorScheme.primary,
      child: SizedBox(
        width: 300,
        height: 120,
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
                          Colors.black.withOpacity(0.1)
                          // Colors.transparent
                        ],
                        // stops: [0, 0.6],
                        // tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            // Image.file(
                            //   File(AppStorage().playingCover!),
                            //   width: double.maxFinite,
                            //   fit: BoxFit.cover,
                            // ),
                            UniImage(url: AppStorage().playingCover!)),
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
                            Text(
                              'playboy',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.primaryContainer,
                              ),
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
                          color: colorScheme.onPrimaryContainer,
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
                        IconButton(
                            color: colorScheme.primaryContainer,
                            // iconSize: 30,
                            onPressed: () {
                              // AppStorage().closeMedia();
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
                            child: SquigglySlider(
                              squiggleAmplitude: 1.4,
                              squiggleWavelength: 4,
                              squiggleSpeed: 0.05,
                              max: AppStorage()
                                  .duration
                                  .inMilliseconds
                                  .toDouble(),
                              value: AppStorage().seeking
                                  ? AppStorage().seekingPos
                                  : min(
                                      AppStorage()
                                          .position
                                          .inMilliseconds
                                          .toDouble(),
                                      AppStorage()
                                          .duration
                                          .inMilliseconds
                                          .toDouble()),
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
                            ),
                          ),
                        ),
                        IconButton(
                            color: colorScheme.primaryContainer,
                            // iconSize: 30,
                            onPressed: () {},
                            icon: const Icon(
                              Icons.skip_next,
                              // size: 30,
                            )),
                        IconButton(
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
                            color: colorScheme.primaryContainer,
                            // iconSize: 30,
                            onPressed: () {
                              AppStorage().closeMedia();
                            },
                            icon: const Icon(
                              Icons.stop,
                              // size: 30,
                            )),
                      ]),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
