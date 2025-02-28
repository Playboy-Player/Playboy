import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/actions.dart' as actions;
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/string_utils.dart';
import 'package:playboy/pages/file/file_card.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({
    super.key,
    required this.path,
  });
  final String path;

  @override
  FileExplorerState createState() => FileExplorerState();
}

class FileExplorerState extends State<FileExplorer> {
  bool _gridview = true;
  bool _loaded = false;
  String _path = '/';
  final List<FileSystemEntity> _contents = [];

  @override
  void initState() {
    super.initState();
    _path = Directory(widget.path).absolute.path;
    _loadDirectory();

    App().actions[actions.gotoDirectory] = _setPath;
  }

  void _loadDirectory() async {
    if (mounted) {
      setState(() {
        _loaded = false;
      });
    }
    Directory dir = Directory(_path);
    _contents.clear();
    try {
      if (!await dir.exists()) {
        return;
      }
      await for (var item in dir.list()) {
        _contents.add(item);
      }
    } catch (e) {
      // _errMsg = e.toString();
    }

    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  void _setPath(String path) {
    setState(() {
      _path = unifyPath(path);
    });
    _loadDirectory();
  }

  List<Widget> _buildLibraryActions(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.08),
      colorScheme.surface,
    );
    return [
      IconButton(
        tooltip: '排序'.l10n,
        hoverColor: backgroundColor,
        onPressed: () async {},
        icon: Icon(
          Icons.sort,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      IconButton(
        tooltip: '切换显示视图'.l10n,
        hoverColor: backgroundColor,
        onPressed: () async {
          setState(() {
            _gridview = !_gridview;
          });
        },
        icon: Icon(
          _gridview ? Icons.calendar_view_month : Icons.view_agenda_outlined,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      IconButton(
        tooltip: '搜索'.l10n,
        hoverColor: backgroundColor,
        onPressed: () async {},
        icon: Icon(
          Icons.search,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      const SizedBox(width: 10),
    ];
  }

  Widget _buildAddressBar(String path) {
    path = unifyPath(Directory(path).absolute.path, endSlash: false);
    var folders = path.split('/');
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              var newPath = (folders.sublist(0, index + 1)).join('/');
              if (!newPath.endsWith('/')) newPath += '/';
              _setPath(newPath);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                folders[index],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 30,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
            ),
          );
        },
        itemCount: folders.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 200;
    final cols = max((width / 120).round(), 2);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 22,
        title: _buildAddressBar(_path),
        actions: _buildLibraryActions(context),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: _loaded
          ? GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: 5 / 6,
              ),
              itemBuilder: (context, index) {
                var e = _contents[index];
                if (e is File) {
                  if (LibraryHelper.supportFormats.contains(
                    extension(e.path),
                  )) {
                    return FileCard(
                      source: e.path,
                      icon: Icons.video_file_outlined,
                    );
                  } else {
                    return FileCard(
                      source: e.path,
                      icon: null,
                    );
                  }
                } else if (e is Directory) {
                  return MInteractiveWrapper(
                    menuController: MenuController(),
                    menuChildren: const [],
                    onTap: () {
                      _setPath(e.path);
                    },
                    borderRadius: 20,
                    child: MCoverCard(
                      cover: null,
                      title: basename(e.path),
                      aspectRatio: 1,
                      icon: Icons.folder,
                    ),
                  );
                }
                return null;
              },
              itemCount: _contents.length,
            )
          : const Center(
              heightFactor: 10,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
