// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      wbiKey: json['wbiKey'] as String? ?? "none",
      keyTime: (json['keyTime'] as num?)?.toInt() ?? 1245974400,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeCode: (json['themeCode'] as num?)?.toInt() ?? 4,
      logined: json['logined'] as bool? ?? false,
      wavySlider: json['wavySlider'] as bool? ?? false,
      showMediaCard: json['showMediaCard'] as bool? ?? true,
      initPage: (json['initPage'] as num?)?.toInt() ?? 0,
      playlistListview: json['playlistListview'] as bool? ?? false,
      musicLibListview: json['musicLibListview'] as bool? ?? false,
      videoLibListview: json['videoLibListview'] as bool? ?? false,
      searchListview: json['searchListview'] as bool? ?? false,
      defaultSearchOption: (json['defaultSearchOption'] as num?)?.toInt() ?? 0,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoDownload: json['autoDownload'] as bool? ?? false,
      defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
      continueToPlay: (json['continueToPlay'] as num?)?.toInt() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      rememberStatus: json['rememberStatus'] as bool? ?? true,
      playAfterExit: json['playAfterExit'] as bool? ?? true,
      videoPaths: (json['videoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      musicPaths: (json['musicPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      favouritePaths: (json['favouritePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      screenshotPath: json['screenshotPath'] as String? ?? '',
      downloadPath: json['downloadPath'] as String? ?? '',
      enableDevSettings: json['enableDevSettings'] as bool? ?? false,
      tabletUI: json['tabletUI'] as bool? ?? true,
      tryLook: json['tryLook'] as bool? ?? true,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'wbiKey': instance.wbiKey,
      'keyTime': instance.keyTime,
      'logined': instance.logined,
      'wavySlider': instance.wavySlider,
      'showMediaCard': instance.showMediaCard,
      'initPage': instance.initPage,
      'playlistListview': instance.playlistListview,
      'musicLibListview': instance.musicLibListview,
      'videoLibListview': instance.videoLibListview,
      'searchListview': instance.searchListview,
      'defaultSearchOption': instance.defaultSearchOption,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeCode': instance.themeCode,
      'autoPlay': instance.autoPlay,
      'autoDownload': instance.autoDownload,
      'defaultMusicMode': instance.defaultMusicMode,
      'continueToPlay': instance.continueToPlay,
      'volume': instance.volume,
      'speed': instance.speed,
      'rememberStatus': instance.rememberStatus,
      'playAfterExit': instance.playAfterExit,
      'videoPaths': instance.videoPaths,
      'musicPaths': instance.musicPaths,
      'favouritePaths': instance.favouritePaths,
      'screenshotPath': instance.screenshotPath,
      'downloadPath': instance.downloadPath,
      'enableDevSettings': instance.enableDevSettings,
      'tryLook': instance.tryLook,
      'tabletUI': instance.tabletUI,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
