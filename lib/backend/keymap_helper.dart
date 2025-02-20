import 'package:flutter/services.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/pages/media/fullscreen_play_page.dart';

class KeyMapHelper {
  static bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        AppStorage().playboy.command(['seek', '-5']);
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        AppStorage().playboy.command(['seek', '5']);
      } else if (event.physicalKey == PhysicalKeyboardKey.space) {
        AppStorage().playboy.playOrPause();
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {
        FullscreenPlayPage.exitFullscreen?.call();
      }
    }
    return false;
  }
}
