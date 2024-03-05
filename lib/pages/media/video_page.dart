import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/widgets/video_card.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<PlayItem> playitems = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    playitems.addAll(
        await LibraryHelper.getPlayItemList(AppStorage().settings.videoPaths));
    if (!mounted) return;
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 200).round(), 2);
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
                '视频',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              // background:
            ),
            pinned: true,
            expandedHeight: 80,
            actions: [
              Container(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: FloatingActionButton.extended(
                  heroTag: 'add_video',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {},
                  icon: const Icon(Icons.library_add_outlined),
                  label: const Text('添加'),
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
                                    Symbols.upcoming_rounded,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '没有视频',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 10 / 9,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return VideoCard(info: playitems[index]);
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
