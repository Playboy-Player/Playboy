//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  // Account Settings;
  String wbiKey;
  int keyTime;
  bool logined;

  // Display Settings;
  String font;
  String fallbackfont;
  bool wavySlider;
  bool showMediaCard;
  int initPage;
  bool playlistListview;
  bool musicLibListview;
  bool videoLibListview;
  bool searchListview;
  int defaultSearchOption;
  ThemeMode themeMode;
  int themeCode;

  // Player Settings
  bool autoPlay;
  bool autoDownload;
  bool defaultMusicMode;

  // 0:ask 1:never 2:always
  int continueToPlay;

  // int defaultQuality;
  double volume;
  double speed;
  bool rememberStatus;
  bool playAfterExit;

  // Storage Settings
  bool getCoverOnScan;
  List<String> videoPaths;
  List<String> musicPaths;
  List<String> favouritePaths;
  String screenshotPath;
  String downloadPath;

  // Language Settings
  String language;

  // BvTools Settings
  bool enableBvTools;
  bool tryLook;

  // Dev Settings
  bool tabletUI;
  bool enableTitleBar;
  double titleBarOffset;

  AppSettings({
    // Account Settings;
    this.wbiKey = 'none',
    this.keyTime = 1245974400,
    this.logined = false,

    // Display Settings,
    this.font = '',
    this.fallbackfont = 'SimHei', // 黑体
    this.wavySlider = false,
    this.showMediaCard = true,
    this.initPage = 0,
    this.playlistListview = false,
    this.musicLibListview = false,
    this.videoLibListview = false,
    this.searchListview = false,
    this.defaultSearchOption = 0,
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
    this.musicPaths = const [],
    this.favouritePaths = const [],
    this.screenshotPath = '',
    this.downloadPath = '',

    // Language Settings
    this.language = 'zh',

    // BvTools Settings
    this.enableBvTools = false,
    this.tryLook = true,

    // Dev Settings
    this.tabletUI = true,
    this.enableTitleBar = true,
    this.titleBarOffset = 0,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
