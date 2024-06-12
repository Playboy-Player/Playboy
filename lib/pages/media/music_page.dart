import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/widgets/music_card.dart';
import 'package:playboy/widgets/playlist_picker.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<PlayItem> playitems = [];
  bool loaded = false;
  bool gridview = true;

  @override
  void initState() {
    super.initState();
    _init();
    gridview = !AppStorage().settings.musicLibListview;
    AppStorage().updateMusicPage = () async {
      setState(() {
        loaded = false;
      });
      playitems.clear();
      playitems.addAll(await LibraryHelper.getPlayItemList(
          AppStorage().settings.musicPaths));
      setState(() {
        loaded = true;
      });
    };
  }

  void _init() async {
    playitems.addAll(
        await LibraryHelper.getPlayItemList(AppStorage().settings.musicPaths));
    if (!mounted) return;
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 160).round(), 2);
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        colorScheme.primary.withOpacity(0.08), colorScheme.surface);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: Text(
                '音乐',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              // background:
            ),
            pinned: true,
            expandedHeight: 80,
            collapsedHeight: 60,
            actions: [
              // Container(
              //   padding: const EdgeInsets.only(top: 10, bottom: 10),
              //   child: FloatingActionButton(
              //     heroTag: 'scan_music',
              //     tooltip: '重新扫描',
              //     elevation: 0,
              //     hoverElevation: 0,
              //     highlightElevation: 0,
              //     backgroundColor: colorScheme.surface,
              //     hoverColor: backgroundColor,
              //     onPressed: () async {
              //       setState(() {
              //         loaded = false;
              //       });
              //       playitems.clear();
              //       playitems.addAll(await LibraryHelper.getPlayItemList(
              //           AppStorage().settings.musicPaths));
              //       setState(() {
              //         loaded = true;
              //       });
              //     },
              //     child: const Icon(Icons.scanner),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                child: FloatingActionButton(
                  heroTag: 'view_music',
                  tooltip: '切换显示视图',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () async {
                    setState(() {
                      gridview = !gridview;
                    });
                  },
                  child: Icon(gridview
                      ? Icons.calendar_view_month
                      : Icons.view_agenda_outlined),
                ),
              ),
            ],
          ),
          loaded
              ? (playitems.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const SizedBox(
                            height: 200,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upcoming_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '没有音乐',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: gridview
                          ? SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 6,
                                crossAxisCount: cols,
                                childAspectRatio: 5 / 6,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  // return MusicCard(info: playitems[index]);
                                  MenuController menuController =
                                      MenuController();
                                  return GestureDetector(
                                    onSecondaryTapDown: (details) {
                                      menuController.open(
                                          position: details.localPosition);
                                    },
                                    child: MenuAnchor(
                                      controller: menuController,
                                      style: MenuStyle(
                                        surfaceTintColor:
                                            const MaterialStatePropertyAll(
                                                Colors.transparent),
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                      menuChildren: [
                                        MenuItemButton(
                                          leadingIcon: const Icon(
                                              Icons.play_arrow_outlined),
                                          child: const Text('播放'),
                                          onPressed: () {
                                            AppStorage().closeMedia();
                                            AppStorage()
                                                .openMedia(playitems[index]);
                                          },
                                        ),
                                        MenuItemButton(
                                          leadingIcon:
                                              const Icon(Icons.menu_open),
                                          child: const Text('插播'),
                                          onPressed: () {},
                                        ),
                                        MenuItemButton(
                                          leadingIcon:
                                              const Icon(Icons.last_page),
                                          child: const Text('最后播放'),
                                          onPressed: () {},
                                        ),
                                        MenuItemButton(
                                          leadingIcon: const Icon(
                                              Icons.add_circle_outline),
                                          child: const Text('添加到播放列表'),
                                          onPressed: () {
                                            showDialog(
                                              barrierColor: colorScheme
                                                  .surfaceTint
                                                  .withOpacity(0.12),
                                              useRootNavigator: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                surfaceTintColor:
                                                    Colors.transparent,
                                                title: const Text('添加到播放列表'),
                                                content: SizedBox(
                                                  width: 200,
                                                  height: 300,
                                                  child: ListView.builder(
                                                    itemBuilder:
                                                        (context, indexList) {
                                                      return SizedBox(
                                                        height: 60,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          onTap: () {
                                                            LibraryHelper
                                                                .addItemToPlaylist(
                                                                    AppStorage()
                                                                            .playlists[
                                                                        indexList],
                                                                    playitems[
                                                                        index]);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: PlaylistPickerItem(
                                                              info: AppStorage()
                                                                      .playlists[
                                                                  indexList]),
                                                        ),
                                                      );
                                                    },
                                                    itemCount: AppStorage()
                                                        .playlists
                                                        .length,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                      child: MusicCard(info: playitems[index]),
                                    ),
                                  );
                                },
                                childCount: playitems.length,
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return SizedBox(
                                    height: 70,
                                    child:
                                        MusicListCard(info: playitems[index]),
                                  );
                                },
                                childCount: playitems.length,
                              ),
                            ),
                    ))
              : const SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }
}
