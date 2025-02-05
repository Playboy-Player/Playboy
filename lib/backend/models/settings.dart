//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:playboy/backend/models/playitem.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  // Appearance Settings;
  String font;
  bool wavySlider;
  int initPage;
  bool playlistListview;
  bool videoLibListview;
  bool searchListview;
  ThemeMode themeMode;
  int themeCode;

  // Player Settings
  bool autoPlay;
  bool autoDownload;
  bool defaultMusicMode;

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

  // RemotePlay Settings
  bool discoverable;

  // Dev Settings
  bool tabletUI;
  bool enableTitleBar;

  AppSettings({
    // Display Settings,
    this.font = '',
    this.wavySlider = false,
    this.initPage = 0,
    this.playlistListview = false,
    this.videoLibListview = false,
    this.searchListview = false,
    this.themeMode = ThemeMode.system,
    this.themeCode = 4,

    // Player Settings
    this.autoPlay = true,
    this.autoDownload = false,
    this.defaultMusicMode = false,
    // 0:ask 1:never 2:always
    this.continueToPlay = 0,
    this.volume = 100,
    this.speed = 1,
    this.rememberStatus = true,
    this.playAfterExit = true,

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
    this.language = 'zh',

    // RemotePlay Settings
    this.discoverable = false,

    // Dev Settings
    this.tabletUI = true,
    this.enableTitleBar = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
