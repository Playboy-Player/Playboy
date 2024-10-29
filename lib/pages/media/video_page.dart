import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/pages/media/m_player.dart';
import 'package:playboy/widgets/playlist_picker.dart';
import 'package:playboy/widgets/video_card.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<PlayItem> playitems = [];
  bool loaded = false;
  bool gridview = true;

  @override
  void initState() {
    super.initState();
    _init();
    gridview = !AppStorage().settings.videoLibListview;
    AppStorage().updateVideoPage = () async {
      setState(() {
        loaded = false;
      });
      playitems.clear();
      playitems.addAll(await LibraryHelper.getMediaFromPaths(
          AppStorage().settings.videoPaths));
      setState(() {
        loaded = true;
      });
    };
  }

  void _init() async {
    playitems.addAll(await LibraryHelper.getMediaFromPaths(
        AppStorage().settings.videoPaths));
    if (!mounted) return;
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 180).round(), 2);
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
                context.l10n.video,
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
              //     heroTag: 'scan_video',
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
              //           AppStorage().settings.videoPaths));
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
                  heroTag: 'view_video',
                  tooltip: Intl.message('切换显示视图', name: "Toggle Display View"),
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
                          child: SizedBox(
                            height: 200,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.upcoming_rounded,
                                    size: 40,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    context.l10n.no_video,
                                    style: const TextStyle(fontSize: 20),
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
                                childAspectRatio: 8 / 7,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  // return VideoCard(info: playitems[index]);
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
                                            const WidgetStatePropertyAll(
                                                Colors.transparent),
                                        shape: WidgetStatePropertyAll(
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
                                          child: Text(context.l10n.play),
                                          onPressed: () async {
                                            await AppStorage()
                                                .closeMedia()
                                                .then((value) {
                                              if (!context.mounted) return;
                                              AppStorage()
                                                  .openMedia(playitems[index]);

                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MPlayer(),
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                        MenuItemButton(
                                          leadingIcon:
                                              const Icon(Icons.menu_open),
                                          child: Text(context.l10n.insert_play),
                                          onPressed: () {},
                                        ),
                                        MenuItemButton(
                                          leadingIcon:
                                              const Icon(Icons.last_page),
                                          child: Text(context.l10n.last_played),
                                          onPressed: () {},
                                        ),
                                        MenuItemButton(
                                          leadingIcon: const Icon(
                                              Icons.add_circle_outline),
                                          child: Text(
                                              context.l10n.add_to_playlist),
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
                                                title: Text(context
                                                    .l10n.add_to_playlist),
                                                content: SizedBox(
                                                  width: 300,
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
                                      child: VideoCard(info: playitems[index]),
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
                                    height: 80,
                                    child:
                                        VideoListCard(info: playitems[index]),
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

  // Widget _buildOption(IconData? icon, String text, Function()? tap) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(text),
  //     trailing: const Icon(Icons.keyboard_arrow_right),
  //     onTap: tap,
  //   );
  // }
}
