import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playboy/backend/constants.dart';
import 'package:playboy/backend/models/settings.dart';

// TODO: redirect app path
class AppStorage extends ChangeNotifier {
  late AppSettings settings;
  // late List<PlaylistItem> playlists;
  // late List<PlayItem> musicLibrary;
  // late List<PlayItem> videoLibrary;
  final playlistPage = GlobalKey<NavigatorState>();
  final musicPage = GlobalKey<NavigatorState>();
  final videoPage = GlobalKey<NavigatorState>();
  final filePage = GlobalKey<NavigatorState>();
  final searchPage = GlobalKey<NavigatorState>();

  Player playboy = Player();
  String? playingCover;
  String playingTitle = 'Not Playing';
  Duration position = const Duration();
  Duration duration = const Duration();
  bool playing = false;

  bool loop = false;
  bool shuffle = false;

  bool seeking = false;
  double seekingPos = 0;

  static final AppStorage _instance = AppStorage._internal();
  factory AppStorage() => _instance;
  AppStorage._internal() {
    settings = AppSettings();
    playboy.stream.position.listen((event) {
      position = event;
      notifyListeners();
    });
    playboy.stream.playing.listen((event) {
      playing = event;
      notifyListeners();
    });
    playboy.stream.duration.listen((event) {
      duration = event;
      notifyListeners();
    });
  }

  void init() {
    loadSettings();
    playboy.setVolume(AppStorage().settings.volume);
  }

  void loadSettings() async {
    var settingsPath = "${Constants.dataPath}config/settings.json";
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
    var settingsPath = "${Constants.dataPath}config/settings.json";
    var fp = File(settingsPath);
    var data = settings.toJson();
    var str = jsonEncode(data);
    fp.writeAsStringSync(str);
    // notifyListeners();
  }

  void updateStatus() {
    notifyListeners();
  }

  // void closeMedia() {
  //   playingCover = null;
  //   playingTitle = 'Not Playing';
  //   AppStorage().playboy.stop();
  //   if (playboy.platform is NativePlayer) {
  //     (playboy.platform as NativePlayer).setProperty('audio-files', '');
  //   }
  // }

  // void openMedia(PlayItem media) {
  //   if (playing) {
  //     closeMedia();
  //   }
  //   AppStorage().duration = Duration.zero;
  //   AppStorage().position = Duration.zero;
  //   final video = Media(media.source);
  //   playboy.open(video);
  //   playingCover = media.cover;
  //   playingTitle = basenameWithoutExtension(media.title);
  // }
}
