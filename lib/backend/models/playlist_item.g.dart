// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistItem _$PlaylistItemFromJson(Map<String, dynamic> json) => PlaylistItem(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PlayItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlaylistItemToJson(PlaylistItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };
