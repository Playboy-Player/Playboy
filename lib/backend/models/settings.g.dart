// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      font: json['font'] as String? ?? '',
      initPage: (json['initPage'] as num?)?.toInt() ?? 0,
      playlistListview: json['playlistListview'] as bool? ?? false,
      videoLibListview: json['videoLibListview'] as bool? ?? false,
      searchListview: json['searchListview'] as bool? ?? false,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeCode: (json['themeCode'] as num?)?.toInt() ?? 4,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoDownload: json['autoDownload'] as bool? ?? false,
      keepOpen: json['keepOpen'] as bool? ?? true,
      preciseSeek: json['preciseSeek'] as bool? ?? false,
      listMode: (json['listMode'] as num?)?.toInt() ?? 0,
      defaultVolume: (json['defaultVolume'] as num?)?.toDouble() ?? 100,
      defaultSpeed: (json['defaultSpeed'] as num?)?.toDouble() ?? 1,
      defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
      continueToPlay: (json['continueToPlay'] as num?)?.toInt() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      rememberStatus: json['rememberStatus'] as bool? ?? true,
      playAfterExit: json['playAfterExit'] as bool? ?? true,
      mpvOptions: (json['mpvOptions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      mpvProperties: (json['mpvProperties'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      getCoverOnScan: json['getCoverOnScan'] as bool? ?? false,
      videoPaths: (json['videoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      favouritePaths: (json['favouritePaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      screenshotPath: json['screenshotPath'] as String? ?? '',
      downloadPath: json['downloadPath'] as String? ?? '',
      recordRecentSearched: json['recordRecentSearched'] as bool? ?? false,
      recentSearched: (json['recentSearched'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recordRecentPlayed: json['recordRecentPlayed'] as bool? ?? false,
      recentPlayed: (json['recentPlayed'] as List<dynamic>?)
              ?.map((e) => PlayItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      language: json['language'] as String? ?? 'zh_hans',
      enableDevSettings: json['enableDevSettings'] as bool? ?? false,
      tabletUI: json['tabletUI'] as bool? ?? true,
      enableTitleBar: json['enableTitleBar'] as bool? ?? true,
      libmpvPath: json['libmpvPath'] as String? ?? '',
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'font': instance.font,
      'initPage': instance.initPage,
      'playlistListview': instance.playlistListview,
      'videoLibListview': instance.videoLibListview,
      'searchListview': instance.searchListview,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeCode': instance.themeCode,
      'autoPlay': instance.autoPlay,
      'autoDownload': instance.autoDownload,
      'keepOpen': instance.keepOpen,
      'preciseSeek': instance.preciseSeek,
      'listMode': instance.listMode,
      'defaultVolume': instance.defaultVolume,
      'defaultSpeed': instance.defaultSpeed,
      'defaultMusicMode': instance.defaultMusicMode,
      'mpvProperties': instance.mpvProperties,
      'mpvOptions': instance.mpvOptions,
      'continueToPlay': instance.continueToPlay,
      'volume': instance.volume,
      'speed': instance.speed,
      'rememberStatus': instance.rememberStatus,
      'playAfterExit': instance.playAfterExit,
      'getCoverOnScan': instance.getCoverOnScan,
      'videoPaths': instance.videoPaths,
      'favouritePaths': instance.favouritePaths,
      'screenshotPath': instance.screenshotPath,
      'downloadPath': instance.downloadPath,
      'recordRecentSearched': instance.recordRecentSearched,
      'recentSearched': instance.recentSearched,
      'recordRecentPlayed': instance.recordRecentPlayed,
      'recentPlayed': instance.recentPlayed,
      'language': instance.language,
      'enableDevSettings': instance.enableDevSettings,
      'tabletUI': instance.tabletUI,
      'enableTitleBar': instance.enableTitleBar,
      'libmpvPath': instance.libmpvPath,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
