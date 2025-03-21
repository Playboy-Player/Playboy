import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';

Widget buildMediaSeekbar(Function callback) {
  return StreamBuilder(
    stream: App().player.stream.duration,
    builder: (context, snapshot) {
      return StreamBuilder(
        stream: App().player.stream.position,
        builder: (context, snapshot) {
          double pos = App().player.state.position.inMilliseconds.toDouble();
          double dur = App().player.state.duration.inMilliseconds.toDouble();
          pos = min(pos, dur);
          return Slider(
            max: dur,
            value: pos,
            onChanged: (value) {
              App().seekingPos = value;
              callback();
            },
            onChangeStart: (value) {
              App().seeking = true;
              callback();
            },
            onChangeEnd: (value) {
              App().player.seek(Duration(milliseconds: value.toInt()));
              App().seeking = false;
              callback();
            },
          );
        },
      );
    },
  );
}
