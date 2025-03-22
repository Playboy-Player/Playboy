import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/backend/utils/string_utils.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
import 'package:playboy/pages/file/file_card.dart';
import 'package:playboy/pages/library/common_media_menu.dart';
import 'package:playboy/widgets/cover_card.dart';
import 'package:playboy/widgets/cover_listtile.dart';
import 'package:playboy/widgets/empty_holder.dart';
import 'package:playboy/widgets/error_holder.dart';
import 'package:playboy/widgets/interactive_wrapper.dart';
import 'package:playboy/widgets/loading_holder.dart';
import 'package:playboy/widgets/menu/menu_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  String _errorMessage = '';
  final List<FileSystemEntity> _contents = [];

  @override
  void initState() {
    super.initState();
    _path = Directory(widget.path).absolute.path;
    _loadDirectory();

    App().actions['gotoDirectory'] = _setPath;
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

      _contents.sort((a, b) {
        if (a is Directory && b is! Directory) return -1;
        if (a is! Directory && b is Directory) return 1;
        return basename(a.path)
            .toLowerCase()
            .compareTo(basename(b.path).toLowerCase());
      });
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
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
    return [
      IconButton(
        tooltip: '切换显示视图'.l10n,
        hoverColor: colorScheme.actionHoverColor,
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
        tooltip: '系统文件管理器'.l10n,
        hoverColor: colorScheme.actionHoverColor,
        onPressed: () async {
          launchUrlString(_path);
        },
        icon: Icon(
          Icons.open_in_browser,
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 22,
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: _buildAddressBar(_path),
            pinned: true,
            actions: _buildLibraryActions(context),
          ),
          _buildLibraryview(context),
        ],
      ),
    );
  }

  Widget _buildLibraryview(BuildContext context) {
    if (!_loaded) return const MLoadingPlaceHolder();
    if (_errorMessage != '') {
      return ErrorHolder(message: _errorMessage).toSliver();
    }
    if (_contents.isEmpty) return const MEmptyHolder().toSliver();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: _gridview ? _buildGridview(context) : _buildListview(context),
    );
  }

  Widget _buildGridview(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 200;
    final cols = max((width / 120).round(), 2);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 6,
        crossAxisCount: cols,
        childAspectRatio: 5 / 6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
        childCount: _contents.length,
      ),
    );
  }

  Widget _buildListview(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var e = _contents[index];
          if (e is File) {
            return MCoverListTile(
              aspectRatio: 1,
              height: 50,
              cover: null,
              icon: Icons.insert_drive_file_outlined,
              label: basename(e.path),
              onTap: () {
                if (LibraryHelper.supportFormats.contains(extension(e.path))) {
                  if (!context.mounted) return;
                  App().openMedia(
                    PlayItem(source: e.path, title: e.path),
                  );

                  App().actions['togglePlayer']?.call();
                }
              },
              actions: [
                MenuButton(
                  menuChildren: [
                    const SizedBox(height: 10),
                    ...buildCommonMediaMenuItems(
                      context,
                      colorScheme,
                      PlayItem(
                        source: e.path,
                        title: basename(
                          e.path,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            );
          } else if (e is Directory) {
            return MCoverListTile(
              aspectRatio: 1,
              height: 50,
              cover: null,
              icon: Icons.folder,
              label: basename(e.path),
              onTap: () {
                _setPath(e.path);
              },
              actions: const [],
            );
          }
          return null;
        },
        childCount: _contents.length,
      ),
    );
  }
}
