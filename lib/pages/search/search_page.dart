import 'package:flutter/material.dart';
import 'package:playboy/pages/search/search_result.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  bool isSearching = false;
  TextEditingController controller = TextEditingController();
  FocusNode inputNode = FocusNode();
  int choosed = 0;
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
                    isSearching = focus;
                  });
                },
                child: TextField(
                  focusNode: inputNode,
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      alignment: Alignment.center,
                      width: 50,
                      child: const Icon(Icons.search),
                    ),
                    suffixIcon: isSearching
                        ? Container(
                            alignment: Alignment.centerLeft,
                            width: 46,
                            child: IconButton(
                              icon: const Icon(
                                Icons.cancel_outlined,
                                weight: 600,
                              ),
                              onPressed: () {
                                controller.clear();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          )
                        : null,
                    labelText: '搜索播放列表, 媒体文件...',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withValues(alpha: 0.4),
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            SearchResultPage(
                          keyword: value,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ).then((value) {
                      inputNode.requestFocus();
                    });
                  },
                ),
              )),
            ),
          ),
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          //     child: Text(
          //       '最近搜索',
          //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Card(
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         side: BorderSide(
          //           color: Theme.of(context).colorScheme.outline,
          //         ),
          //         borderRadius: const BorderRadius.all(Radius.circular(20)),
          //       ),
          //       child: const SizedBox(
          //         height: 150,
          //         child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 Icons.upcoming_rounded,
          //                 size: 40,
          //               ),
          //               SizedBox(
          //                 width: 10,
          //               ),
          //               Text(
          //                 '没有最近搜索',
          //                 style: TextStyle(fontSize: 20),
          //               ),
          //             ]),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
