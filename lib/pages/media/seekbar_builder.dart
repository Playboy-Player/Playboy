import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/time_utils.dart';

Widget buildMediaSeekbar(Function callback) {
  return StreamBuilder(
    stream: App().playboy.stream.position,
    builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
      return Slider(
        max: App().duration.inMilliseconds.toDouble(),
        value: App().seeking
            ? App().seekingPos
            : bounded(
                0,
                snapshot.hasData
                    ? snapshot.data!.inMilliseconds.toDouble()
                    : App().position.inMilliseconds.toDouble(),
                App().duration.inMilliseconds.toDouble(),
              ),
        onChanged: (value) {
          App().seekingPos = value;
          // setState(() {
          // });
          callback();
        },
        onChangeStart: (value) {
          App().seeking = true;
          // setState(() {
          // });
          callback();
        },
        onChangeEnd: (value) {
          // App().playboy.seek(Duration(milliseconds: value.toInt())).then(
          //       (_) => {
          //         setState(() {
          //           App().seeking = false;
          //         })
          //       },
          //     );
          App().playboy.seek(Duration(milliseconds: value.toInt()));
          App().seeking = false;
          callback();
        },
      );
    },
  );
}
