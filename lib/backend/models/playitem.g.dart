// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playitem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayItem _$PlayItemFromJson(Map<String, dynamic> json) => PlayItem(
      source: json['source'] as String,
      cover: json['cover'] as String?,
      title: json['title'] as String,
    );

Map<String, dynamic> _$PlayItemToJson(PlayItem instance) => <String, dynamic>{
      'source': instance.source,
      'cover': instance.cover,
      'title': instance.title,
    };
