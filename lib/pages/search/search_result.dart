import 'package:flutter/material.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({
    super.key,
    required this.keyword,
    required this.result,
  });
  final String keyword;
  final List<Widget> result;

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {
  bool _gridview = true;

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
            ),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      body: Container(),
    );
  }
}
