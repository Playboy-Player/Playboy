//dart run build_runner build

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'settings.g.dart';

@JsonSerializable()
class AppSettings {
  //Account Settings;
  String wbiKey;
  int keyTime;
  bool logined;

  //Display Settings;
  ThemeMode themeMode;
  int themeCode;

  bool autoRotation;
  bool globalCopyable;

  //Player Settings
  bool autoPlay;
  bool autoDownload;
  bool defaultMusicMode;
  //0:ask 1:never 2:always
  int continueToPlay;
  // int defaultQuality;
  double volume;
  bool silent;
  double speed;
  bool rememberStatus;
  bool tryLook;

  //Storage Settings
  List<String> videoPaths;
  List<String> musicPaths;
  String screenshotPath;
  String downloadPath;

  AppSettings({
    this.wbiKey = "none",
    this.keyTime = 1245974400, //090626
    this.themeMode = ThemeMode.system,
    this.themeCode = 0,
    this.logined = false,
    this.autoRotation = false,
    this.globalCopyable = false,
    this.autoPlay = true,
    this.autoDownload = false,
    this.defaultMusicMode = false,
    this.continueToPlay = 0,
    this.volume = 100,
    this.silent = false,
    this.speed = 1,
    this.rememberStatus = true,
    this.tryLook = true,
    this.videoPaths = const [],
    this.musicPaths = const [],
    this.screenshotPath = '',
    this.downloadPath = '',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  MaterialColor getColorTheme() {
    switch (themeCode) {
      case 0:
        return Colors.pink;
      case 1:
        return Colors.red;
      case 2:
        return Colors.deepPurple;
      case 3:
        return Colors.indigo;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.blueGrey;
    }
    return Colors.pink;
  }
}
