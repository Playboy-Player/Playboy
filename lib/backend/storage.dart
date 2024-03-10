import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/models/settings.dart';

class AppStorage extends ChangeNotifier {
  late AppSettings settings;
  // late List<PlayItem> musicLibrary;
  // late List<PlayItem> videoLibrary;
  final playlistPage = GlobalKey<NavigatorState>();
  final musicPage = GlobalKey<NavigatorState>();
  final videoPage = GlobalKey<NavigatorState>();
  final filePage = GlobalKey<NavigatorState>();
  final searchPage = GlobalKey<NavigatorState>();

  List<PlaylistItem> playlists = [];
  PlaylistItem currentPlaylist =
      PlaylistItem(items: [], title: 'Current Playing #2rf8eu', cover: null);
  int playingIndex = 0;

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
  }

  Future<void> init() async {
    dataPath = (await getApplicationSupportDirectory()).path;
    loadSettings();
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
      saveSettings();
    }
    playboy.setVolume(settings.volume);
    playboy.setRate(settings.speed);
    // playlists.addAll(await LibraryHelper.loadPlaylists());
  }

  void loadSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    if (!fp.existsSync()) {
      fp.createSync(recursive: true);
      var data = AppSettings().toJson();
      var str = jsonEncode(data);
      fp.writeAsStringSync(str);
    }
    settings = AppSettings.fromJson(jsonDecode(fp.readAsStringSync()));
    // notifyListeners();
  }

  void saveSettings() async {
    var settingsPath = "$dataPath/config/settings.json";
    var fp = File(settingsPath);
    var data = settings.toJson();
    var str = jsonEncode(data);
    fp.writeAsStringSync(str);
    // notifyListeners();
  }

  void updateStatus() {
    notifyListeners();
  }

  Future<void> closeMedia() async {
    AppStorage().playboy.stop();
    if (AppStorage().playboy.platform is NativePlayer) {
      (AppStorage().playboy.platform as NativePlayer)
          .setProperty('audio-files', '');
    }
    AppStorage().playingTitle = 'Not Playing';
    AppStorage().playingCover = null;
  }

  void openMedia(PlayItem media) {
    // TODO: 支持字幕功能
    // AppStorage().playboy.setSubtitleTrack(SubtitleTrack.no());
    if (!AppStorage().settings.rememberStatus) {
      AppStorage().playboy.setVolume(100);
      AppStorage().playboy.setRate(1);
      AppStorage().settings.volume = 100;
      AppStorage().settings.speed = 1;
      AppStorage().saveSettings();
    }
    AppStorage().duration = Duration.zero;
    AppStorage().position = Duration.zero;
    final video = Media(media.source);
    AppStorage().playboy.open(video, play: AppStorage().settings.autoPlay);
    AppStorage().position = Duration.zero;
    AppStorage().duration = Duration.zero;
    AppStorage().playingTitle = basenameWithoutExtension(media.title);
    AppStorage().playingCover = media.cover;
  }
}
