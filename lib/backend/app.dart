import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/basic/basic_video_controller.dart';
import 'package:media_kit_video/basic/basic_video_controller_configuration.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/models/settings.dart';
import 'package:playboy/pages/home.dart';

class App extends ChangeNotifier {
  late final String dataPath;

  late AppSettings settings;

  final contentKey = GlobalKey<NavigatorState>();
  void dialog(Widget Function(BuildContext) builder) {
    if (contentKey.currentState != null) {
      showDialog(
        useRootNavigator: false,
        context: contentKey.currentState!.context,
        builder: builder,
      );
    }
  }

  late Function() updateVideoPage;
  Map<String, Function> actions = {};

  late final NativePlayer playboy;
  late final BasicVideoController controller;

  bool playlistLoaded = false;
  bool mediaLibraryLoaded = false;
  List<PlaylistItem> playlists = [];
  List<PlayItem> mediaLibrary = [];

  String? playingCover;
  String? mediaPath;
  String playingTitle = 'Not Playing';
  int playingIndex = 0;
  bool loop = false;
  bool shuffle = false;
  Duration position = const Duration();
  Duration duration = const Duration();
  bool playing = false;
  bool seeking = false;
  double seekingPos = 0;

  int voWidth = 0;
  int voHeight = 0;
  void refreshVO() {
    controller.setSize(width: voWidth, height: voHeight);
    playboy.command(['show-text', '已更新显示区域']);
  }

  void restoreVO() {
    controller.setSize();
    playboy.command(['show-text', '已恢复默认显示大小']);
  }

  static final App _instance = App._internal();
  factory App() => _instance;
  App._internal() {
    settings = AppSettings();
  }

  Future<void> init() async {
    dataPath = (await getApplicationSupportDirectory()).path;
    await loadSettings();
    bool needsUpdate = false;
    if (settings.screenshotPath == '') {
      settings.screenshotPath = '$dataPath/screenshots';
      var dir = Directory(settings.screenshotPath);
      if (!await dir.exists()) {
        dir.create();
      }
      needsUpdate = true;
    }
    if (needsUpdate) {
      await saveSettings();
    }
    playboy = NativePlayer(
      options: {
        'config-dir': dataPath,
        'config': 'yes',
        'input-default-bindings': 'yes',
        'osd-level': '0',
      },
    );
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
        mediaPath = src;
        if (src.startsWith('http')) {
          return;
        } else {
          playingTitle = basenameWithoutExtension(src);
          playingCover = '${withoutExtension(src)}.cover.jpg';
        }
      } else {
        playingTitle = 'Not Playing';
        playingCover = null;
      }
      notifyListeners();
    });
    controller = await BasicVideoController.create(
      playboy,
      const BasicVideoControllerConfiguration(),
    );
    playboy.setVolume(settings.volume);
    if (settings.preciseSeek) playboy.setProperty('hr-seek', 'yes');
    // playboy.setProperty('hr-seek-framedrop', 'no');

    // These arguments can avoid crashing on switch media (only tested on Windows)
    // https://github.com/mpv-player/mpv/commit/703f1588803eaa428e09c0e5547b26c0fff476a7
    // https://github.com/mpv-android/mpv-android/commit/9e5c3d8a630290fc41edb8b03aeafa3bc4c45955
    playboy.setProperty('scale', 'bilinear');
    playboy.setProperty('dscale', 'bilinear');
    playboy.setProperty('dither', 'no');
    playboy.setProperty('correct-downscaling', 'no');
    playboy.setProperty('linear-downscaling', 'no');
    playboy.setProperty('sigmoid-upscaling', 'no');
    playboy.setProperty('hdr-compute-peak', 'no');
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

  void executeAction(String action) {
    actions[action]?.call();
  }

  void updateStatus() {
    HomePage.refresh?.call();
  }

  Future<void> closeMedia() async {
    playboy.stop();
    playingTitle = 'Not Playing';
    playingCover = null;
    shuffle = false;
  }

  void openMedia(PlayItem media) {
    if (!settings.rememberStatus) {
      _resetPlayerStatus();
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

  void openPlaylist(PlaylistItem playlistItem, bool shuffleList) {
    if (playlistItem.items.isEmpty) {
      return;
    }
    if (!settings.rememberStatus) {
      _resetPlayerStatus();
    }
    duration = Duration.zero;
    position = Duration.zero;
    if (shuffleList) {
      playboy.open(LibraryHelper.convertToPlaylist(playlistItem), play: false);
      playboy.setShuffle(true);
      playboy.jump(0);
      if (App().settings.autoPlay) playboy.play();
    } else {
      playboy.open(
        LibraryHelper.convertToPlaylist(playlistItem),
        play: App().settings.autoPlay,
      );
    }
    position = Duration.zero;
    duration = Duration.zero;
    playingTitle = basenameWithoutExtension(playlistItem.items.first.title);
    playingCover = playlistItem.items.first.cover;
    shuffle = shuffleList;
  }

  void _resetPlayerStatus() {
    playboy.setVolume(settings.defaultVolume);
    playboy.setRate(settings.defaultSpeed);
  }

  // currently it doesn't work
  // https://github.com/media-kit/media-kit/issues/722
  void appendPlaylist(PlaylistItem pl) {
    for (var item in pl.items) {
      playboy.add(Media(item.source));
    }
  }
}
