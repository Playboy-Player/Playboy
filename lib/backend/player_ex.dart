import 'package:flutter/foundation.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';
import 'package:libmpv_dart/libmpv.dart';

// mpv-version
// mpv-configuration
// ffmpeg-version
// libass-version

// video render feature from libmpv_dart

class PlayerEx extends Player {
  final ValueNotifier<bool> videoAvaiable = ValueNotifier<bool>(false);
  final ValueNotifier<int> index = ValueNotifier<int>(0);
  final ValueNotifier<PlaylistItem> playlist = ValueNotifier<PlaylistItem>(
    PlaylistItem(
      title: 'empty-list',
      items: [],
    ),
  );

  PlayerEx(
    super.options, {
    super.videoOutput,
    super.initialize,
  }) {
    super.observeProperty('playing-pos', mpv_format.MPV_FORMAT_INT64);
    super.propertyChangedCallback = (name, format) {};
  }

  Future<void> showText(String text) async {
    command(['show-text', text]);
  }

  Future<void> open(PlayItem media) async {
    command(['loadfile', media.source]);
  }

  Future<void> openList(PlaylistItem playlist) async {
    for (var media in playlist.items) {
      command(['loadfile', media.source, 'append']);
    }
  }

  Future<void> stop() async {
    command(['stop']);
  }

  Future<void> playOrPause() async {
    command(['cycle', 'pause']);
  }

  Future<void> play() async {}

  Future<void> pause() async {}

  Future<void> jump() async {}

  Future<void> remove() async {}

  Future<void> setSpeed() async {}

  Future<void> setVolume() async {}

  Future<void> setSubtitle() async {}

  Future<void> setListMode() async {}

  Future<void> setShuffle() async {}

  Future<void> prev() async {
    command(['playlist-prev']);
  }

  Future<void> next() async {
    command(['playlist-next']);
  }

  Future<void> seek(int secs, {bool absoulte = true}) async {
    command([
      'seek',
      secs.toString(),
      if (absoulte) 'absolute',
    ]);
  }
}
