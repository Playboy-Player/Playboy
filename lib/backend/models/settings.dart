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

  // bool autoRotation;
  // bool globalCopyable;

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
  List<String> videoPaths;
  List<String> musicPaths;
  List<String> favouritePaths;
  String screenshotPath;
  String downloadPath;

  // Dev Settings
  bool enableBvTools;
  bool tryLook;
  bool tabletUI;

  AppSettings({
    this.wbiKey = "none",
    this.keyTime = 1245974400, //090626
    this.themeMode = ThemeMode.system,
    this.themeCode = 4,
    this.logined = false,
    this.wavySlider = false,
    this.showMediaCard = true,
    this.initPage = 0,
    this.playlistListview = false,
    this.musicLibListview = false,
    this.videoLibListview = false,
    this.searchListview = false,
    this.defaultSearchOption = 0,
    // this.autoRotation = false,
    // this.globalCopyable = false,
    this.autoPlay = true,
    this.autoDownload = false,
    this.defaultMusicMode = false,
    this.continueToPlay = 0,
    this.volume = 100,
    this.speed = 1,
    this.rememberStatus = true,
    this.playAfterExit = true,
    this.videoPaths = const [],
    this.musicPaths = const [],
    this.favouritePaths = const [],
    this.screenshotPath = '',
    this.downloadPath = '',
    this.enableBvTools = false,
    this.tabletUI = true,
    this.tryLook = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
