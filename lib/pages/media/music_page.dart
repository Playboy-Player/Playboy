import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';
import 'package:playboy/widgets/music_card.dart';

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
      playitems.addAll(await LibraryHelper.getMediaFromPaths(
          AppStorage().settings.musicPaths));
      setState(() {
        loaded = true;
      });
    };
  }

  void _init() async {
    playitems.addAll(await LibraryHelper.getMediaFromPaths(
        AppStorage().settings.musicPaths));
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
                context.l10n.music,
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
                                    context.l10n.no_music,
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
                                  return MusicCard(info: playitems[index]);
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
