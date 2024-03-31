// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      wbiKey: json['wbiKey'] as String? ?? "none",
      keyTime: json['keyTime'] as int? ?? 1245974400,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeCode: json['themeCode'] as int? ?? 4,
      logined: json['logined'] as bool? ?? false,
      wavySlider: json['wavySlider'] as bool? ?? false,
      showMediaCard: json['showMediaCard'] as bool? ?? true,
      initPage: json['initPage'] as int? ?? 0,
      musicLibListview: json['musicLibListview'] as bool? ?? true,
      videoLibListview: json['videoLibListview'] as bool? ?? true,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoDownload: json['autoDownload'] as bool? ?? false,
      defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
      continueToPlay: json['continueToPlay'] as int? ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      rememberStatus: json['rememberStatus'] as bool? ?? true,
      tryLook: json['tryLook'] as bool? ?? true,
      playAfterExit: json['playAfterExit'] as bool? ?? true,
      videoPaths: (json['videoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      musicPaths: (json['musicPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      screenshotPath: json['screenshotPath'] as String? ?? '',
      downloadPath: json['downloadPath'] as String? ?? '',
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'wbiKey': instance.wbiKey,
      'keyTime': instance.keyTime,
      'logined': instance.logined,
      'wavySlider': instance.wavySlider,
      'showMediaCard': instance.showMediaCard,
      'initPage': instance.initPage,
      'musicLibListview': instance.musicLibListview,
      'videoLibListview': instance.videoLibListview,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeCode': instance.themeCode,
      'autoPlay': instance.autoPlay,
      'autoDownload': instance.autoDownload,
      'defaultMusicMode': instance.defaultMusicMode,
      'continueToPlay': instance.continueToPlay,
      'volume': instance.volume,
      'speed': instance.speed,
      'rememberStatus': instance.rememberStatus,
      'tryLook': instance.tryLook,
      'playAfterExit': instance.playAfterExit,
      'videoPaths': instance.videoPaths,
      'musicPaths': instance.musicPaths,
      'screenshotPath': instance.screenshotPath,
      'downloadPath': instance.downloadPath,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
