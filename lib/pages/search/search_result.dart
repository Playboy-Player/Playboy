import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/backend/utils/string_utils.dart';
import 'package:playboy/pages/library/media_menu.dart';
import 'package:playboy/pages/media/player_page.dart';
import 'package:playboy/pages/playlist/playlist_detail.dart';
import 'package:playboy/pages/playlist/playlist_menu.dart';
import 'package:playboy/pages/search/search_type.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/loading.dart';
import 'package:playboy/widgets/menu_button.dart';
import 'package:playboy/widgets/menu_item.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({
    super.key,
    required this.keyword,
  });
  final String keyword;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {
  bool _gridview = true;
  int _choosed = 0;

  bool _mediaLoaded = false;
  final List<PlayItem> _mediaResult = [];

  bool _playlistLoaded = false;
  final List<PlaylistItem> _playlistResult = [];

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Text('"${widget.keyword}" 的搜索结果'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _gridview = !_gridview;
              });
            },
            icon: Icon(
              _gridview
                  ? Icons.calendar_view_month
                  : Icons.view_agenda_outlined,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          _buildSelector(),
          _buildLibraryview(context),
        ],
      ),
    );
  }

  void _loadResult() async {
    // load media result
    var allMedia = await LibraryHelper.getMediaFromPaths(
      AppStorage().settings.videoPaths,
    );
    _mediaResult.addAll(
      allMedia.where((item) => isSubsequence(widget.keyword, item.title)),
    );
    if (!mounted) return;
    setState(() {
      _mediaLoaded = true;
    });

    // load playlist result
    var allPlaylist = await LibraryHelper.loadPlaylists();
    _playlistResult.addAll(
      allPlaylist.where((item) => isSubsequence(widget.keyword, item.title)),
    );
    if (!mounted) return;
    setState(() {
      _playlistLoaded = true;
    });
  }

  Widget _buildLibraryview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    if (_choosed == SearchType.playlist.id) {
      if (!_playlistLoaded) return const MLoadingPlaceHolder();
      if (_playlistResult.isEmpty) return const MEmptyHolder();

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: _gridview
            ? _buildGridview(
                context,
                List.generate(
                  _playlistResult.length,
                  (index) {
                    PlaylistItem info = _playlistResult[index];
                    return MInteractiveWrapper(
                      menuController: MenuController(),
                      menuChildren:
                          _buildPlaylistMenuItems(context, colorScheme, info),
                      onTap: () async {
                        pushPage(
                          context,
                          PlaylistDetail(info: info),
                        );
                      },
                      borderRadius: 20,
                      child: MCoverCard(
                        aspectRatio: 1,
                        icon: Icons.playlist_play_rounded,
                        cover: info.cover,
                        title: info.title,
                      ),
                    );
                  },
                ),
              )
            : _buildListview(
                context,
                List.generate(
                  _playlistResult.length,
                  (index) {
                    PlaylistItem info = _playlistResult[index];
                    return MCoverListTile(
                      aspectRatio: 1,
                      height: 60,
                      cover: info.cover,
                      icon: Icons.music_note,
                      label: info.title,
                      onTap: () async {
                        pushPage(
                          context,
                          PlaylistDetail(info: info),
                        );
                      },
                      actions: [
                        IconButton(
                          tooltip: '播放',
                          onPressed: () {
                            AppStorage().openPlaylist(info, false);
                          },
                          icon: const Icon(Icons.play_arrow),
                        ),
                        MMenuButton(
                          menuChildren: _buildPlaylistMenuItems(
                              context, colorScheme, info),
                        ),
                      ],
                    );
                  },
                ),
              ),
      );
    }

    if (_choosed == SearchType.media.id) {
      if (!_mediaLoaded) return const MLoadingPlaceHolder();
      if (_mediaResult.isEmpty) return const MEmptyHolder();

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: _gridview
            ? _buildGridview(
                context,
                List.generate(
                  _mediaResult.length,
                  (index) {
                    PlayItem info = _mediaResult[index];
                    return MInteractiveWrapper(
                      menuController: MenuController(),
                      menuChildren: _buildMediaMenuItems(
                        context,
                        colorScheme,
                        info,
                      ),
                      onTap: () async {
                        await AppStorage().closeMedia().then((value) {
                          AppStorage().openMedia(info);
                        });
                        if (!context.mounted) return;
                        pushRootPage(
                          context,
                          const PlayerPage(),
                        );
                        AppStorage().updateStatus();
                      },
                      borderRadius: 20,
                      child: MCoverCard(
                        aspectRatio: 1,
                        icon: Icons.movie_outlined,
                        cover: info.cover,
                        title: info.title,
                      ),
                    );
                  },
                ),
              )
            : _buildListview(
                context,
                List.generate(
                  _mediaResult.length,
                  (index) {
                    PlayItem info = _mediaResult[index];
                    return MCoverListTile(
                      aspectRatio: 1,
                      height: 60,
                      cover: info.cover,
                      icon: Icons.movie_outlined,
                      label: info.title,
                      onTap: () async {
                        await AppStorage().closeMedia().then((_) {
                          AppStorage().openMedia(info);
                          if (!context.mounted) return;
                          pushRootPage(
                            context,
                            const PlayerPage(),
                          );
                        });
                        AppStorage().updateStatus();
                      },
                      actions: [
                        IconButton(
                          tooltip: '播放',
                          onPressed: () {
                            AppStorage().closeMedia();
                            AppStorage().openMedia(info);
                            if (!context.mounted) return;
                            pushRootPage(
                              context,
                              const PlayerPage(),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                        ),
                        MMenuButton(
                          menuChildren: _buildMediaMenuItems(
                            context,
                            colorScheme,
                            info,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      );
    }

    return const MEmptyHolder();
  }

  Widget _buildGridview(BuildContext context, List<Widget> items) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 160).round(), 2);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 6,
        crossAxisCount: cols,
        childAspectRatio: 5 / 6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return items[index];
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context, List<Widget> items) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return items[index];
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildSelector() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 6),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return FilterChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              label: Row(
                children: [
                  Icon(
                    SearchType.values[index].icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(SearchType.values[index].label),
                ],
              ),
              showCheckmark: false,
              onSelected: (value) {
                setState(() {
                  _choosed = SearchType.values[index].id;
                });
              },
              selected: _choosed == SearchType.values[index].id,
            );
          },
          itemCount: SearchType.values.length,
        ),
      ),
    );
  }

  List<Widget> _buildPlaylistMenuItems(
    BuildContext context,
    ColorScheme colorScheme,
    PlaylistItem item,
  ) {
    return [
      const SizedBox(height: 10),
      ...buildCommonPlaylistMenuItems(
        context,
        colorScheme,
        item,
      ),
      const Divider(),
      const MMenuItem(
        icon: Icons.info_outline,
        label: '属性',
        onPressed: null,
      ),
      const SizedBox(height: 10),
    ];
  }

  List<Widget> _buildMediaMenuItems(
    BuildContext context,
    ColorScheme colorScheme,
    PlayItem item,
  ) {
    return [
      const SizedBox(height: 10),
      ...buildCommonMediaMenuItems(context, colorScheme, item),
      const Divider(),
      const MMenuItem(
        icon: Icons.info_outline,
        label: '属性',
        onPressed: null,
      ),
      const SizedBox(height: 10),
    ];
  }
}
