// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playboy/backend/storage.dart';

class KeyMapHelper {
  static void handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final position = AppStorage().position;
      if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        // AppStorage().playboy.pause();
        AppStorage().playboy.seek(position - const Duration(seconds: 3));
        // AppStorage().playboy.play();
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        // AppStorage().playboy.pause();
        AppStorage().playboy.seek(position + const Duration(seconds: 3));
        // AppStorage().playboy.play();
      }
    }
  }
}
