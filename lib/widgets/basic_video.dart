import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/basic/video_controller.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/models/playitem.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

/// a simple implementaion of `media_kit_video` Video Widget
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
  final _subscriptions = <StreamSubscription>[];
  late int? _width = widget.controller.player.state.width;
  late int? _height = widget.controller.player.state.height;
  late bool _visible = (_width ?? 0) > 0 && (_height ?? 0) > 0;

  @override
  void initState() {
    super.initState();
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
    return LayoutBuilder(
      builder: (context, constrain) {
        var factor = MediaQuery.of(context).devicePixelRatio;
        App().voHeight = (constrain.maxHeight * factor).toInt();
        App().voWidth = (constrain.maxWidth * factor).toInt();
        return ValueListenableBuilder<int?>(
          valueListenable: widget.controller.id,
          builder: (context, id, _) {
            return ValueListenableBuilder<Rect?>(
              valueListenable: widget.controller.rect,
              builder: (context, rect, _) {
                if (id != null && rect != null && _visible) {
                  return FittedBox(
                    child: SizedBox(
                      width: rect.width,
                      height: rect.height,
                      child: Texture(textureId: id),
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          var res = await FilePicker.platform
                              .pickFiles(lockParentWindow: true);
                          if (res != null) {
                            String link = res.files.single.path!;
                            App().openMedia(
                              PlayItem(source: link, title: link),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.file_open_outlined,
                          color: Colors.white,
                        ),
                        label: Text(
                          '打开文件'.l10n,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          var editingController = TextEditingController();
                          App().dialog(
                            (BuildContext context) => AlertDialog(
                              surfaceTintColor: Colors.transparent,
                              title: Text('播放网络串流'.l10n),
                              content: TextField(
                                autofocus: true,
                                maxLines: 1,
                                controller: editingController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.link),
                                  border: OutlineInputBorder(),
                                  labelText: 'URL',
                                ),
                                onSubmitted: (value) async {
                                  String link = value;
                                  App().openMedia(
                                    PlayItem(source: link, title: link),
                                  );
                                },
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('取消'.l10n),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String link = editingController.text;
                                    App().openMedia(
                                      PlayItem(source: link, title: link),
                                    );
                                  },
                                  child: Text('确定'.l10n),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        label: Text(
                          '打开 URL'.l10n,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
