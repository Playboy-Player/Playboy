import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/app.dart';

import 'package:path/path.dart';
import 'package:media_kit/media_kit.dart';

class LibraryHelper {
  static const supportFormats = [
    '.avi',
    '.flv',
    '.mkv',
    '.mov',
    '.mp4',
    '.mpeg',
    '.webm',
    '.wmv',
    '.aac',
    '.midi',
    '.mp3',
    '.ogg',
    '.wav',
  ];

  static Playlist convertToPlaylist(PlaylistItem playlistItem) {
    List<Media> res = [];
    for (var item in playlistItem.items) {
      res.add(Media(item.source));
    }
    return Playlist(res);
  }

  static Future<List<PlayItem>> getMediaFromPaths(List<String> paths) async {
    List<PlayItem> res = [];
    var vis = <String>{};

    Queue q = Queue();
    for (var path in paths) {
      if (vis.contains(path)) continue;
      vis.add(path);
      q.add(path);
    }

    vis.clear();
    while (q.isNotEmpty) {
      int n = q.length;
      for (int i = 0; i < n; i++) {
        var p = q.removeFirst();
        if (vis.contains(p)) continue;
        vis.add(p);
        var dir = Directory(p);
        await for (var item in dir.list()) {
          if (item is Directory) {
            if (vis.contains(item.path)) continue;
            q.add(item.path);
          } else if (supportFormats.contains(extension(item.path))) {
            res.add(
              PlayItem(
                source: item.path,
                title: basenameWithoutExtension(item.path),
              ),
            );
          }
        }
      }
    }

    return res;
  }

  static Future<PlayItem> getItemFromFile(String src) async {
    return PlayItem(
      source: src,
      title: basenameWithoutExtension(src),
    );
  }

  static Future<List<PlaylistItem>> loadPlaylists() async {
    var playlists = <PlaylistItem>[];
    var dir = Directory('${App().dataPath}/playlists/');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    await for (var item in dir.list()) {
      if (item is File && extension(item.path) == '.json') {
        var pl = PlaylistItem.fromJson(jsonDecode(await item.readAsString()));
        playlists.add(pl);
      }
    }
    return playlists;
  }

  static void savePlaylist(PlaylistItem pl) {
    var fp = File('${App().dataPath}/playlists/${pl.title}.json');
    if (!fp.existsSync()) {
      fp.createSync(recursive: true);
    }
    var data = pl.toJson();
    fp.writeAsString(jsonEncode(data));
  }

  static void deletePlaylist(PlaylistItem pl) {
    var fp = File('${App().dataPath}/playlists/${pl.title}.json');
    if (fp.existsSync()) {
      fp.deleteSync();
    }

    var cover = File('${App().dataPath}/playlists/${pl.title}.cover.jpg');
    if (cover.existsSync()) {
      cover.deleteSync();
    }
  }

  static void addItemToPlaylist(PlaylistItem pl, PlayItem p) {
    pl.items.add(p);
    savePlaylist(pl);
  }

  static void removeItemFromPlaylist(PlaylistItem pl, PlayItem p) {
    pl.items.remove(p);
    savePlaylist(pl);
  }

  static void renamePlaylist(PlaylistItem pl, String name) {
    pl.title = name;
    savePlaylist(pl);
  }
}
