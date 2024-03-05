import 'package:json_annotation/json_annotation.dart';
part 'playitem.g.dart';

@JsonSerializable()
class PlayItem {
  PlayItem({
    required this.source,
    required this.cover,
    required this.title,
  });
  String source;
  String? cover;
  String title;

  factory PlayItem.fromJson(Map<String, dynamic> json) =>
      _$PlayItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlayItemToJson(this);
}
