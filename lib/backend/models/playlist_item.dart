import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:json_annotation/json_annotation.dart';
part 'playlist_item.g.dart';

@JsonSerializable()
class PlaylistItem {
  PlaylistItem({
    // required this.uuid,
    required this.title,
    required this.items,
    // required this.cover,
  });
  // String uuid;
  String title;
  List<PlayItem> items;
  // String? cover;

  String get cover => '${App().dataPath}/playlists/$title.cover.jpg';

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistItemToJson(this);
}
