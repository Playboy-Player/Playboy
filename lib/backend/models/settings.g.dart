// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      wbiKey: json['wbiKey'] as String? ?? "error",
      keyTime: json['keyTime'] as int? ?? 1245974400,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      themeCode: json['themeCode'] as int? ?? 0,
      logined: json['logined'] as bool? ?? false,
      autoRotation: json['autoRotation'] as bool? ?? false,
      globalCopyable: json['globalCopyable'] as bool? ?? false,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoDownload: json['autoDownload'] as bool? ?? false,
      defaultMusicMode: json['defaultMusicMode'] as bool? ?? false,
      continueToPlay: json['continueToPlay'] as int? ?? 0,
      volume: (json['volume'] as num?)?.toDouble() ?? 100,
      silent: json['silent'] as bool? ?? false,
      speed: (json['speed'] as num?)?.toDouble() ?? 1,
      rememberStatus: json['rememberStatus'] as bool? ?? true,
      tryLook: json['tryLook'] as bool? ?? true,
      videoPaths: (json['videoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      musicPaths: (json['musicPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      screenshotPath: json['screenshotPath'] as String? ?? './screenshots/',
      downloadPath: json['downloadPath'] as String? ?? './downloads/',
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'wbiKey': instance.wbiKey,
      'keyTime': instance.keyTime,
      'logined': instance.logined,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'themeCode': instance.themeCode,
      'autoRotation': instance.autoRotation,
      'globalCopyable': instance.globalCopyable,
      'autoPlay': instance.autoPlay,
      'autoDownload': instance.autoDownload,
      'defaultMusicMode': instance.defaultMusicMode,
      'continueToPlay': instance.continueToPlay,
      'volume': instance.volume,
      'silent': instance.silent,
      'speed': instance.speed,
      'rememberStatus': instance.rememberStatus,
      'tryLook': instance.tryLook,
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
