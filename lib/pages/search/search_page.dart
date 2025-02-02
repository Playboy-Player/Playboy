import 'package:flutter/material.dart';
// import 'package:playboy/backend/utils/route.dart';
// import 'package:playboy/pages/search/search_result.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/library_title.dart';

enum SearchType {
  playlist(id: 0, icon: Icons.menu, label: 'Playlist'),
  music(id: 1, icon: Icons.music_note_outlined, label: 'Music'),
  video(id: 2, icon: Icons.movie_filter_outlined, label: 'Video');

  const SearchType({
    required this.id,
    required this.icon,
    required this.label,
  });
  final int id;
  final IconData icon;
  final String label;
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputNode = FocusNode();
  int _choosedMask = 1;

  @override
  Widget build(BuildContext context) {
    // late final colorScheme = Theme.of(context).colorScheme;
    // late final backgroundColor = Color.alphaBlend(
    //     colorScheme.primary.withOpacity(0.08), colorScheme.surface);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              title: Text(
                '搜索',
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: FocusScope(
                child: Focus(
                  onFocusChange: (focus) {
                    setState(() {
                      _isSearching = focus;
                    });
                  },
                  child: TextField(
                    focusNode: _inputNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        alignment: Alignment.center,
                        width: 50,
                        child: const Icon(Icons.search),
                      ),
                      suffixIcon: _isSearching
                          ? Container(
                              alignment: Alignment.centerLeft,
                              width: 46,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  weight: 600,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            )
                          : null,
                      labelText: '搜索播放列表, 媒体文件...',
                      hintText: '按回车以确认',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withValues(alpha: 0.4),
                    ),
                    onSubmitted: (value) {
                      _confirmSearch(value);
                    },
                  ),
                ),
              ),
            ),
          ),
          _buildSelector(),
          const MLibraryTitle(title: '最近搜索'),
          const MEmptyHolder(),
        ],
      ),
    );
  }

  void _confirmSearch(String value) {
    // pushPage(
    //   context,
    //   SearchResultPage(
    //     keyword: value,
    //   ),
    // ).then((value) {
    //   _inputNode.requestFocus();
    // });
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
              onSelected: (value) {
                setState(() {
                  _choosedMask ^= 1 << SearchType.values[index].id;
                });
              },
              selected: (_choosedMask >> SearchType.values[index].id & 1) == 1,
            );
          },
          itemCount: SearchType.values.length,
        ),
      ),
    );
  }
}
