// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      wbiKey: json['wbiKey'] as String? ?? 'none',
      keyTime: (json['keyTime'] as num?)?.toInt() ?? 1245974400,
      logined: json['logined'] as bool? ?? false,
      font: json['font'] as String? ?? '',
      fallbackfont: json['fallbackfont'] as String? ?? 'SimHei',
      wavySlider: json['wavySlider'] as bool? ?? false,
      showMediaCard: json['showMediaCard'] as bool? ?? true,
      initPage: (json['initPage'] as num?)?.toInt() ?? 0,
      playlistListview: json['playlistListview'] as bool? ?? false,
      musicLibListview: json['musicLibListview'] as bool? ?? false,
      videoLibListview: json['videoLibListview'] as bool? ?? false,
      searchListview: json['searchListview'] as bool? ?? false,
      defaultSearchOption: (json['defaultSearchOption'] as num?)?.toInt() ?? 0,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeCode: (json['themeCode'] as num?)?.toInt() ?? 4,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoDownload: json['autoDownload'] as bool? ?? false,
      defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
      continueToPlay: (json['continueToPlay'] as num?)?.toInt() ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      rememberStatus: json['rememberStatus'] as bool? ?? true,
      playAfterExit: json['playAfterExit'] as bool? ?? true,
      getCoverOnScan: json['getCoverOnScan'] as bool? ?? false,
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
      language: json['language'] as String? ?? 'zh',
      enableBvTools: json['enableBvTools'] as bool? ?? false,
      tryLook: json['tryLook'] as bool? ?? true,
      tabletUI: json['tabletUI'] as bool? ?? true,
      enableTitleBar: json['enableTitleBar'] as bool? ?? true,
      titleBarOffset: (json['titleBarOffset'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'wbiKey': instance.wbiKey,
      'keyTime': instance.keyTime,
      'logined': instance.logined,
      'font': instance.font,
      'fallbackfont': instance.fallbackfont,
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
      'getCoverOnScan': instance.getCoverOnScan,
      'videoPaths': instance.videoPaths,
      'musicPaths': instance.musicPaths,
      'favouritePaths': instance.favouritePaths,
      'screenshotPath': instance.screenshotPath,
      'downloadPath': instance.downloadPath,
      'language': instance.language,
      'enableBvTools': instance.enableBvTools,
      'tryLook': instance.tryLook,
      'tabletUI': instance.tabletUI,
      'enableTitleBar': instance.enableTitleBar,
      'titleBarOffset': instance.titleBarOffset,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
