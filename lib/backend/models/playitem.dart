import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';
part 'playitem.g.dart';

@JsonSerializable()
class PlayItem {
  PlayItem({
    required this.source,
    required this.title,
  });
  String source;
  String title;

  factory PlayItem.fromJson(Map<String, dynamic> json) =>
      _$PlayItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlayItemToJson(this);

  String get cover => '${withoutExtension(source)}.cover.jpg';
}
