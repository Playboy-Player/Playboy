import 'dart:convert';
import 'dart:io';

import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/storage.dart';

class LibraryHelper {
  static const supportFormats = [
    'avi',
    'flv',
    'mkv',
    'mov',
    'mp4',
    'mpeg',
    'webm',
    'wmv',
    'aac',
    'midi',
    'mp3',
    'ogg',
    'wav',
  ];

  static Playlist convertToPlaylist(PlaylistItem playlistItem) {
    List<Media> res = [];
    for (var item in playlistItem.items) {
      res.add(Media(item.source));
    }
    return Playlist(res);
  }

  static Future<List<PlayItem>> getPlayItemList(List<String> paths) async {
    List<PlayItem> res = [];
    Directory dir;
    for (var path in paths) {
      dir = Directory(path);
      var list = dir.list();
      await for (var item in list) {
        if (item is Directory) {
          var tmp = await getItemFromDirectory(item);
          if (tmp != null) {
            res.add(tmp);
          }
        }
      }
    }
    return res;
  }

  static Future<PlayItem?> getItemFromDirectory(Directory dir) async {
    String source = dir.path;
    String title = basenameWithoutExtension(source);
    // source += '/$title.mp4';
    bool found = false;
    String media = '';
    for (var ext in supportFormats) {
      media = '$source/$title.$ext';
      if (await File(media).exists()) {
        found = true;
        break;
      }
    }
    if (!found) {
      return null;
    }
    String cover = '${dir.path}/cover.jpg';
    if (!await File(cover).exists()) {
      return PlayItem(source: media, cover: null, title: title);
    } else {
      return PlayItem(source: media, cover: cover, title: title);
    }
  }

  static Future<PlayItem> getItemFromFile(String src) async {
    var coverPath = '${dirname(src)}/cover.jpg';
    if (await File(coverPath).exists()) {
      return PlayItem(
          source: src, cover: coverPath, title: basenameWithoutExtension(src));
    } else {
      return PlayItem(
          source: src, cover: null, title: basenameWithoutExtension(src));
    }
  }

  static Future<List<PlaylistItem>> loadPlaylists() async {
    var playlists = <PlaylistItem>[];
    var dir = Directory('${AppStorage().dataPath}/playlists/');
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
    var fp = File('${AppStorage().dataPath}/playlists/${pl.title}.json');
    if (!fp.existsSync()) {
      fp.createSync(recursive: true);
    }
    var data = pl.toJson();
    fp.writeAsString(jsonEncode(data));
  }

  static void deletePlaylist(PlaylistItem pl) {
    var fp = File('${AppStorage().dataPath}/playlists/${pl.title}.json');
    if (fp.existsSync()) {
      fp.deleteSync();
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
}
