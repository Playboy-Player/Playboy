import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:media_kit_video/basic/basic_video_controller.dart';
import 'package:playboy/backend/app.dart';

/// a simple implemetaion of `media_kit_video` Video Widget
class BasicVideo extends StatefulWidget {
  const BasicVideo({
    super.key,
    required this.controller,
  });

  final BasicVideoController controller;

  @override
  State<BasicVideo> createState() => _BasicVideoState();
}

class _BasicVideoState extends State<BasicVideo> {
  late final ValueNotifier<BasicVideoController?> _notifier;
  final _subscriptions = <StreamSubscription>[];
  late int? _width = widget.controller.player.state.width;
  late int? _height = widget.controller.player.state.height;
  late bool _visible = (_width ?? 0) > 0 && (_height ?? 0) > 0;

  @override
  void initState() {
    super.initState();
    _notifier = ValueNotifier(widget.controller);
    _subscriptions.addAll(
      [
        widget.controller.player.stream.width.listen(
          (value) {
            _width = value;
            final visible = (_width ?? 0) > 0 && (_height ?? 0) > 0;
            if (_visible != visible) {
              setState(() {
                _visible = visible;
              });
            }
          },
        ),
        widget.controller.player.stream.height.listen(
          (value) {
            _height = value;
            final visible = (_width ?? 0) > 0 && (_height ?? 0) > 0;
            if (_visible != visible) {
              setState(() {
                _visible = visible;
              });
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      var factor = MediaQuery.of(context).devicePixelRatio;
      App().voHeight = (constrain.maxHeight * factor).toInt();
      App().voWidth = (constrain.maxWidth * factor).toInt();
      return FittedBox(
        child: ValueListenableBuilder<BasicVideoController?>(
          valueListenable: _notifier,
          builder: (context, notifier, _) => notifier == null
              ? const SizedBox.shrink()
              : ValueListenableBuilder<int?>(
                  valueListenable: notifier.id,
                  builder: (context, id, _) {
                    return ValueListenableBuilder<Rect?>(
                      valueListenable: notifier.rect,
                      builder: (context, rect, _) {
                        if (id != null && rect != null && _visible) {
                          return SizedBox(
                            width: rect.width,
                            height: rect.height,
                            child: Texture(textureId: id),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
        ),
      );
    });
  }
}
