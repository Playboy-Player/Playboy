import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/models/settings.dart';

class AppStorage extends ChangeNotifier {
  late AppSettings settings;
  List<PlaylistItem> playlists = [];
  int playingIndex = 0;

  late Function() updateFilePage;
  late Function() scanMusic;
  late Function() scanVideo;

  late final Player playboy;
  late final VideoController controller;

  String? playingCover;
  String playingTitle = 'Not Playing';
  Duration position = const Duration();
  Duration duration = const Duration();
  bool playing = false;

  bool loop = false;
  bool shuffle = false;

  bool seeking = false;
  double seekingPos = 0;

  String dataPath = '';

  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;
  AppStorage._internal() {
    settings = AppSettings();
    playboy = Player();
    controller = VideoController(playboy);
    playboy.stream.position.listen((event) {
      position = event;
    });
    playboy.stream.playing.listen((event) {
      playing = event;
    });
    playboy.stream.duration.listen((event) {
      duration = event;
    });
    playboy.stream.playlist.listen((event) {
      playingIndex = event.index;
      if (event.medias.isNotEmpty) {
        var src = event.medias[playingIndex].uri;
        if (src.startsWith('http')) {
          return;
        } else {
          playingTitle = basenameWithoutExtension(src);
          var coverPath = '${dirname(src)}/cover.jpg';
          if (File(coverPath).existsSync()) {
            playingCover = coverPath;
          } else {
            playingCover = null;
          }
        }
      } else {
        playingTitle = 'Not Playing';
        playingCover = null;
      }
      notifyListeners();
    });
  }

  Future<void> init() async {
    dataPath = (await getApplicationSupportDirectory()).path;
    await loadSettings();
    bool needsUpdate = false;
    if (settings.downloadPath == '') {
      settings.downloadPath = '$dataPath/downloads';
      needsUpdate = true;
    }
    if (settings.screenshotPath == '') {
      settings.screenshotPath = '$dataPath/screenshots';
      needsUpdate = true;
    }
    if (needsUpdate) {
      await saveSettings();
    }
    playboy.setVolume(settings.volume);
    playboy.setRate(settings.speed);
  }

  Future<void> loadSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    if (!await fp.exists()) {
      await fp.create(recursive: true);
      var data = AppSettings().toJson();
      var str = jsonEncode(data);
      await fp.writeAsString(str);
    }
    settings = AppSettings.fromJson(jsonDecode(await fp.readAsString()));
  }

  Future<void> saveSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    var data = settings.toJson();
    var str = jsonEncode(data);
    await fp.writeAsString(str);
  }

  void updateStatus() {
    notifyListeners();
  }

  Future<void> closeMedia() async {
    playboy.stop();
    if (playboy.platform is NativePlayer) {
      (playboy.platform as NativePlayer).setProperty('audio-files', '');
    }
    playingTitle = 'Not Playing';
    playingCover = null;
    shuffle = false;
  }

  void openMedia(PlayItem media) {
    if (!settings.rememberStatus) {
      playboy.setVolume(100);
      playboy.setRate(1);
      settings.volume = 100;
      settings.speed = 1;
      saveSettings();
    }
    duration = Duration.zero;
    position = Duration.zero;
    final video = Media(media.source);
    playboy.open(video, play: settings.autoPlay);
    position = Duration.zero;
    duration = Duration.zero;
    playingTitle = basenameWithoutExtension(media.title);
    playingCover = media.cover;
    shuffle = false;
  }

  void openPlaylist(PlaylistItem pl) {
    if (pl.items.isEmpty) {
      return;
    }
    if (!settings.rememberStatus) {
      playboy.setVolume(100);
      playboy.setRate(1);
      settings.volume = 100;
      settings.speed = 1;
      saveSettings();
    }
    duration = Duration.zero;
    position = Duration.zero;
    playboy.open(LibraryHelper.convertToPlaylist(pl),
        play: AppStorage().settings.autoPlay);
    position = Duration.zero;
    duration = Duration.zero;
    playingTitle = basenameWithoutExtension(pl.items[0].title);
    playingCover = pl.items[0].cover;
    shuffle = false;
  }

  void openPlaylistShuffle(PlaylistItem pl) {
    if (pl.items.isEmpty) {
      return;
    }
    if (!settings.rememberStatus) {
      playboy.setVolume(100);
      playboy.setRate(1);
      settings.volume = 100;
      settings.speed = 1;
      saveSettings();
    }
    duration = Duration.zero;
    position = Duration.zero;
    playboy.open(LibraryHelper.convertToPlaylist(pl), play: false);
    playboy.setShuffle(true);
    playboy.jump(0);
    if (AppStorage().settings.autoPlay) {
      playboy.play();
    }
    position = Duration.zero;
    duration = Duration.zero;
    playingTitle = basenameWithoutExtension(pl.items[0].title);
    playingCover = pl.items[0].cover;
    shuffle = true;
  }
}
