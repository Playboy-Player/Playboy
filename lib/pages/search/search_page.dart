import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
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
                '搜索',
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
                  heroTag: 'filter',
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  backgroundColor: colorScheme.surface,
                  hoverColor: backgroundColor,
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('选项'),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: FocusScope(
                  child: Focus(
                onFocusChange: (focus) {
                  setState(() {
                    isSearching = focus;
                  });
                },
                child: TextField(
                  // autofocus: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(
                              Symbols.cancel_rounded,
                              weight: 600,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              // searchController.clear();
                              // widget.onSearchTextChanged('');
                            },
                          )
                        : null,
                    labelText: '搜索媒体文件',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              )),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                '最近文件',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const SizedBox(
                  height: 150,
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
                          '没有最近文件',
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
