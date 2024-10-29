import 'package:flutter/material.dart';
import 'package:playboy/l10n/i10n.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key, required this.keyword});
  final String keyword;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {
  int choosed = 0;

  bool gridview = true;

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
          child: Text('"${widget.keyword}" ${context.l10n.search_results}'),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {
              setState(() {
                gridview = !gridview;
              });
            },
            icon: Icon(gridview
                ? Icons.calendar_view_month
                : Icons.view_agenda_outlined),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 16,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.web_stories_outlined),
                  label: Text(context.l10n.play),
                  onSelected: (value) {
                    setState(() {
                      choosed = 0;
                    });
                  },
                  selected: choosed == 0,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.music_note_outlined),
                  label: Text(context.l10n.music),
                  onSelected: (value) {
                    setState(() {
                      choosed = 1;
                    });
                  },
                  selected: choosed == 1,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.movie_filter_outlined),
                  label: Text(context.l10n.video),
                  onSelected: (value) {
                    setState(() {
                      choosed = 2;
                    });
                  },
                  selected: choosed == 2,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.folder_outlined),
                  label: Text(context.l10n.favorites),
                  onSelected: (value) {
                    setState(() {
                      choosed = 3;
                    });
                  },
                  selected: choosed == 3,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.history),
                  label: Text(context.l10n.history),
                  onSelected: (value) {
                    setState(() {
                      choosed = 4;
                    });
                  },
                  selected: choosed == 4,
                ),
                const SizedBox(
                  width: 6,
                ),
                FilterChip(
                  showCheckmark: false,
                  avatar: const Icon(Icons.live_tv),
                  label: const Text('BV Tools'),
                  onSelected: (value) {
                    setState(() {
                      choosed = 5;
                    });
                  },
                  selected: choosed == 5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
