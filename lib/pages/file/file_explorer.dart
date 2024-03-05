import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/widgets/file_card.dart';
import 'package:playboy/widgets/folder_card.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({super.key, required this.path});
  final String path;

  @override
  FileExplorerState createState() => FileExplorerState();
}

class FileExplorerState extends State<FileExplorer> {
  bool loaded = false;
  List<FileSystemEntity> contents = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    Directory dir = Directory(widget.path);
    if (!await dir.exists()) {
      return;
    }
    await for (var item in dir.list()) {
      contents.add(item);
    }

    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = max((width / 150).round(), 2);
    String name = basename(widget.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: loaded
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  // childAspectRatio: 10 / 9,
                ),
                itemBuilder: (context, index) {
                  var e = contents[index];
                  if (e is File) {
                    if (extension(e.path) == '.mp4') {
                      return FileCard(
                          source: e.path, icon: Icons.audio_file_outlined);
                    } else {
                      return FileCard(source: e.path, icon: null);
                    }
                  } else if (e is Directory) {
                    return FolderCard(source: e.path, icon: null);
                  }
                  return null;
                },
                itemCount: contents.length,
              ),
            )
          : const Center(
              heightFactor: 10,
              child: CircularProgressIndicator(),
            ),
    );
  }
}
