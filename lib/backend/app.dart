import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/basic/basic_video_controller.dart';
import 'package:media_kit_video/basic/basic_video_controller_configuration.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:playboy/backend/keymap_helper.dart';
import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:playboy/backend/models/settings.dart';
import 'package:playboy/pages/home.dart';

class App {
  late final String dataPath;

  late AppSettings settings;

  final contentKey = GlobalKey<NavigatorState>();
  void dialog(Widget Function(BuildContext) builder) {
    if (contentKey.currentState != null) {
      KeyMapHelper.keyBindinglock++;
      showDialog(
        useRootNavigator: false,
        context: contentKey.currentState!.context,
        builder: builder,
      ).whenComplete(() {
        KeyMapHelper.keyBindinglock--;
      });
    }
  }

  Map<String, Function> actions = {};

  late final NativePlayer player;
  late final BasicVideoController controller;

  bool playlistLoaded = false;
  bool mediaLibraryLoaded = false;
  List<PlaylistItem> playlists = [];
  List<PlayItem> mediaLibrary = [];

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
    player = NativePlayer(
      options: {
        'config-dir':
            settings.mpvConfigPath != '' ? settings.mpvConfigPath : dataPath,
        'config': settings.enableMpvConfig ? 'yes' : 'no',
        'input-default-bindings': settings.useDefaultKeyBinding ? 'yes' : 'no',
        'osd-level': settings.mpvOsdLevel.toString(),
      },
    );
    player.stream.playlist.listen(
      (event) {
        if (event.medias.isNotEmpty) {
          var src = event.medias[event.index].uri;
          playingTitle = basenameWithoutExtension(src);
          playingCover = '${withoutExtension(src)}.cover.jpg';
        } else {
          playingTitle = 'Not Playing';
          playingCover = null;
        }
      },
    );
    controller = await BasicVideoController.create(
      player,
      const BasicVideoControllerConfiguration(),
    );
    player.setVolume(settings.volume);
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

  String? playingCover;
  String playingTitle = 'Not Playing';

  bool loop = false;

  bool seeking = false;
  double seekingPos = 0;

  int voWidth = 0;
  int voHeight = 0;
  void refreshVO() {
    controller.setSize(width: voWidth, height: voHeight);
    player.command(['show-text', '已更新显示区域']);
  }

  void restoreVO() {
    controller.setSize();
    player.command(['show-text', '已恢复默认显示大小']);
  }

  void openMedia(PlayItem media) {
    if (!settings.rememberStatus) {
      _resetPlayerStatus();
    }
    final video = Media(media.source);
    player.open(video, play: settings.autoPlay);
  }

  void openPlaylist(PlaylistItem playlistItem, bool shuffleList) {
    if (playlistItem.items.isEmpty) {
      return;
    }
    if (!settings.rememberStatus) {
      _resetPlayerStatus();
    }
    if (shuffleList) {
      player.open(LibraryHelper.convertToPlaylist(playlistItem), play: false);
      player.setShuffle(true);
      player.jump(0);
      if (App().settings.autoPlay) player.play();
    } else {
      player.open(
        LibraryHelper.convertToPlaylist(playlistItem),
        play: App().settings.autoPlay,
      );
    }
  }

  void _resetPlayerStatus() {
    player.setVolume(settings.defaultVolume);
    player.setRate(settings.defaultSpeed);
  }

  void appendPlaylist(PlaylistItem pl) {
    for (var item in pl.items) {
      player.add(Media(item.source));
    }
  }
}
