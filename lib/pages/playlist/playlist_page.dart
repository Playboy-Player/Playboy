import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/widgets/playlist_card.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => PlaylistState();
}

class PlaylistState extends State<PlaylistPage> {
  final TextEditingController editingController = TextEditingController();
  // List<PlaylistItem> playlists = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    AppStorage().playlists.addAll(await LibraryHelper.loadPlaylists());
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
                '播放列表',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              // background:
            ),
            pinned: true,
            expandedHeight: 80,
            collapsedHeight: 65,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FloatingActionButton(
                  heroTag: 'new_list',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {
                    editingController.clear();
                    showDialog(
                      barrierColor: colorScheme.surfaceTint.withOpacity(0.12),
                      useRootNavigator: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        title: const Text('新建播放列表'),
                        content: TextField(
                          autofocus: true,
                          maxLines: 1,
                          controller: editingController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '名称',
                          ),
                          onSubmitted: (value) {
                            var pl = PlaylistItem(
                                items: [], title: value, cover: null);
                            LibraryHelper.savePlaylist(pl);
                            setState(() {
                              AppStorage().playlists.add(pl);
                            });
                            Navigator.pop(context);
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              var pl = PlaylistItem(
                                  items: [],
                                  title: editingController.text,
                                  cover: null);
                              LibraryHelper.savePlaylist(pl);
                              setState(() {
                                AppStorage().playlists.add(pl);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.playlist_add),
                  // label: const Text('新建'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: FloatingActionButton.extended(
                  isExtended: MediaQuery.of(context).size.width > 500,
                  heroTag: 'view_list',
                  // tooltip: '切换显示视图',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {},
                  // icon: const Icon(Icons.view_agenda_outlined),
                  // label: const Text('列表视图'),
                  icon: const Icon(Icons.calendar_view_month),
                  label: const Text('网格'),
                ),
              ),
            ],
          ),
          loaded
              ? (AppStorage().playlists.isEmpty
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
                                    '没有播放列表',
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
                            MenuController menuController = MenuController();
                            return GestureDetector(
                              onSecondaryTapDown: (details) {
                                menuController.open(
                                    position: details.localPosition);
                              },
                              child: MenuAnchor(
                                anchorTapClosesMenu: true,
                                controller: menuController,
                                style: MenuStyle(
                                  surfaceTintColor:
                                      const MaterialStatePropertyAll(
                                          Colors.transparent),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                menuChildren: [
                                  const MenuItemButton(
                                    leadingIcon:
                                        Icon(Icons.play_arrow_outlined),
                                    child: Text('顺序播放'),
                                  ),
                                  const MenuItemButton(
                                    leadingIcon: Icon(Icons.shuffle),
                                    child: Text('随机播放'),
                                  ),
                                  const MenuItemButton(
                                    leadingIcon: Icon(Icons.add),
                                    child: Text('追加到当前列表'),
                                  ),
                                  const MenuItemButton(
                                    leadingIcon:
                                        Icon(Icons.drive_file_rename_outline),
                                    child: Text('重命名'),
                                  ),
                                  MenuItemButton(
                                    leadingIcon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    child: const Text('删除'),
                                    onPressed: () {
                                      LibraryHelper.deletePlaylist(
                                          AppStorage().playlists[index]);
                                      AppStorage().playlists.removeAt(index);
                                      setState(() {});
                                    },
                                  )
                                ],
                                child: PlaylistCard(
                                    info: AppStorage().playlists[index]),
                              ),
                            );
                          },
                          childCount: AppStorage().playlists.length,
                        ),
                      ),
                    ))
              : const SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 10,
                    child: CircularProgressIndicator(),
                  ),
                )
        ],
      ),
    );
  }
}
