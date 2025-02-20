import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/route_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/pages/search/search_result.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/library/library_title.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputNode = FocusNode();

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
                '搜索'.l10n,
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
                      labelText: '搜索播放列表, 媒体文件...'.l10n,
                      hintText: '按回车以确认'.l10n,
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
          // _buildSelector(),
          MLibraryTitle(title: '最近搜索'.l10n),
          const MEmptyHolder().toSliver(),
        ],
      ),
    );
  }

  void _confirmSearch(String value) {
    pushPage(
      context,
      SearchResultPage(
        keyword: value,
      ),
    ).then((value) {
      _inputNode.requestFocus();
    });
  }
}
