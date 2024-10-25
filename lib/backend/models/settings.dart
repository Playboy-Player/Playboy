//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  // Account Settings;
  String wbiKey = 'none';
  int keyTime = 1245974400;
  bool logined = false;

  // Display Settings;
  bool wavySlider = false;
  bool showMediaCard = true;
  int initPage = 0;
  bool playlistListview = false;
  bool musicLibListview = false;
  bool videoLibListview = false;
  bool searchListview = false;
  int defaultSearchOption = 0;
  ThemeMode themeMode = ThemeMode.system;
  int themeCode = 4;

  // Player Settings
  bool autoPlay = true;
  bool autoDownload = false;
  bool defaultMusicMode = false;

  // 0:ask 1:never 2:always
  int continueToPlay = 0;

  // int defaultQuality;
  double volume = 100;
  double speed = 1;
  bool rememberStatus = true;
  bool playAfterExit = true;

  // Storage Settings
  List<String> videoPaths = [];
  List<String> musicPaths = [];
  List<String> favouritePaths = [];
  String screenshotPath = '';
  String downloadPath = '';

  // Language Settings
  String language = 'zh';

  // BvTools Settings
  bool enableBvTools = false;
  bool tryLook = true;

  // Dev Settings
  bool tabletUI = true;
  bool enableTitleBar = true;
  double titleBarOffset = 0;

  AppSettings({
    // Account Settings;
    this.wbiKey = 'none',
    this.keyTime = 1245974400,
    this.logined = false,

    // Display Settings,
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
