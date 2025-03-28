import 'package:media_kit/media_kit.dart';

extension MediaUtils on Playlist {
  Media get current => medias[index];
}
