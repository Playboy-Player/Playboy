// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistItem _$PlaylistItemFromJson(Map<String, dynamic> json) => PlaylistItem(
      uuid: json['uuid'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PlayItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      cover: json['cover'] as String?,
    );

Map<String, dynamic> _$PlaylistItemToJson(PlaylistItem instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'items': instance.items,
      'title': instance.title,
      'cover': instance.cover,
    };
