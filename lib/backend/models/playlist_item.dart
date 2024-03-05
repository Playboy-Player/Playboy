import 'package:playboy/backend/models/playitem.dart';
import 'package:json_annotation/json_annotation.dart';
part 'playlist_item.g.dart';

@JsonSerializable()
class PlaylistItem {
  PlaylistItem({
    required this.items,
    required this.title,
    required this.cover,
  });
  List<PlayItem> items;
  String title;
  String? cover;

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistItemToJson(this);
}
