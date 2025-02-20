//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:playboy/backend/models/playitem.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  // Appearance Settings;
  String font;
  int initPage;
  bool playlistListview;
  bool videoLibListview;
  bool searchListview;
  ThemeMode themeMode;
  int themeCode;

  // Player Settings
  bool autoPlay;
  bool autoDownload;
  bool keepOpen;
  bool preciseSeek;
  int listMode;
  double defaultVolume;
  double defaultSpeed;
  bool defaultMusicMode;
  Map<String, String> mpvProperties;
  Map<String, String> mpvOptions;

  // 0:ask 1:never 2:always
  int continueToPlay;
  double volume;
  double speed;
  bool rememberStatus;
  bool playAfterExit;

  // Storage Settings
  bool getCoverOnScan;
  List<String> videoPaths;
  List<String> favouritePaths;
  String screenshotPath;
  String downloadPath;

  bool recordRecentSearched;
  List<String> recentSearched;
  bool recordRecentPlayed;
  List<PlayItem> recentPlayed;

  // Language Settings
  String language;

  // Dev Settings
  bool enableDevSettings;
  bool tabletUI;
  bool enableTitleBar;
  String libmpvPath;

  AppSettings({
    // Display Settings,
    this.font = '',
    this.initPage = 0,
    this.playlistListview = false,
    this.videoLibListview = false,
    this.searchListview = false,
    this.themeMode = ThemeMode.system,
    this.themeCode = 4,

    // Player Settings
    this.autoPlay = true,
    this.autoDownload = false,
    this.keepOpen = true,
    this.preciseSeek = false,
    this.listMode = 0,
    this.defaultVolume = 100,
    this.defaultSpeed = 1,
    this.defaultMusicMode = false,
    // 0:ask 1:never 2:always
    this.continueToPlay = 0,
    this.volume = 100,
    this.speed = 1,
    this.rememberStatus = true,
    this.playAfterExit = true,
    this.mpvOptions = const {},
    this.mpvProperties = const {},

    // Storage Settings
    this.getCoverOnScan = false,
    this.videoPaths = const [],
    this.favouritePaths = const [],
    this.screenshotPath = '',
    this.downloadPath = '',
    this.recordRecentSearched = false,
    this.recentSearched = const [],
    this.recordRecentPlayed = false,
    this.recentPlayed = const [],

    // Language Settings
    this.language = 'zh_hans',

    // Dev Settings
    this.enableDevSettings = false,
    this.tabletUI = true,
    this.enableTitleBar = true,
    this.libmpvPath = '',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
