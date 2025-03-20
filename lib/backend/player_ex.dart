/*

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:libmpv_dart/libmpv.dart';

import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/models/playlist_item.dart';

// mpv-version
// mpv-configuration
// ffmpeg-version
// libass-version

// video render feature from libmpv_dart

class PlayerEx extends Player {
  final ValueNotifier<bool> videoAvaiable = ValueNotifier(false);
  final ValueNotifier<bool> shuffle = ValueNotifier(false);

  final ValueNotifier<int> index = ValueNotifier(0);
  final ValueNotifier<PlaylistItem?> playlist = ValueNotifier(null);
  final ValueNotifier<PlayItem?> playingItem = ValueNotifier(null);
  final ValueNotifier<LoopMode> loopMode = ValueNotifier(LoopMode.none);

  PlayerEx(
    super.options, {
    super.videoOutput,
    super.initialize,
  }) {
    <String, mpv_format>{
      'playlist-playing-pos': mpv_format.MPV_FORMAT_INT64,
    }.forEach(
      (name, format) => observeProperty(name, format),
    );

    super.propertyChangedCallback = (event) {
      final prop = event.ref.data.cast<mpv_event_property>();
      final propName = prop.ref.name.cast<Utf8>().toDartString();
      if (propName == 'playlist-playing-pos' &&
          prop.ref.format == mpv_format.MPV_FORMAT_INT64 &&
          prop.ref.data != nullptr) {
        final index_ = prop.ref.data.cast<Int64>().value;
        if (index_ >= 0) {
          if (playlist.value != null) {
            int n = playlist.value!.items.length;
            if (0 <= index_ && index_ < n) {
              playingItem.value = playlist.value!.items[index_];
            }
          }
          index.value = index_;
        }
      }
    };
  }

  Future<void> showText(String text) async {
    command(['show-text', text]);
  }

  Future<void> open(PlayItem media) async {
    openList(PlaylistItem(title: 'default-playlist', items: [media]));
  }

  Future<void> openList(PlaylistItem playlist_, {bool shuffle_ = false}) async {
    if (playlist_.items.isEmpty) return;
    pause();
    stop();
    videoAvaiable.value = true;
    for (var media in playlist_.items) {
      command(['loadfile', media.source, 'append']);
    }
    if (shuffle_) {
      setShuffle(true);
      jump(0);
    }
    playingItem.value = playlist_.items.first;
    playlist.value = playlist_;
    setPropertyFlag('pause', !App().settings.autoPlay);
  }

  Future<void> stop() async {
    videoAvaiable.value = false;
    playlist.value = null;
    command(['stop']);
  }

  Future<void> playOrPause() async {
    command(['cycle', 'pause']);
  }

  Future<void> play() async {
    setPropertyFlag('pause', false);
  }

  Future<void> pause() async {
    setPropertyFlag('pause', true);
  }

  Future<void> jump(int pos) async {
    setPropertyInt64('playlist-pos', pos);
  }

  Future<void> remove(int pos) async {
    var newList = playlist.value;
    if (newList != null) {
      if (0 <= pos && pos < newList.items.length) {
        command(['playlist-remove', pos.toString()]);
        playlist.value = PlaylistItem(
          title: newList.title,
          items: newList.items..removeAt(pos),
        );
      }
    }
  }

  Future<void> setSpeed(double value) async {
    if (value < 0) return;
    setPropertyDouble('speed', value);
  }

  Future<void> setVolume(double value) async {
    if (value < 0) return;
    setPropertyDouble('volume', value);
  }

  Future<void> setSubtitle() async {}

  Future<void> setListMode(LoopMode mode) async {
    switch (mode) {
      case LoopMode.none:
        setPropertyString('loop-file', 'no');
        setPropertyString('loop-playlist', 'no');
      case LoopMode.loop:
        setPropertyString('loop-file', 'no');
        setPropertyString('loop-playlist', 'yes');
      case LoopMode.single:
        setPropertyString('loop-file', 'yes');
        setPropertyString('loop-playlist', 'no');
    }
    loopMode.value = mode;
  }

  Future<void> setShuffle(bool value) async {
    if (value) {
      command(['playlist-shuffle']);
    } else {
      command(['playlist-unshuffle']);
    }
  }

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

enum LoopMode {
  none,
  loop,
  single,
}

*/
