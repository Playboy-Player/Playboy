import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:playboy/backend/app.dart';

class KeyMapHelper {
  static void init() {
    loadKeyBindings();
    ServicesBinding.instance.keyboard.addHandler(_handleKeyEvent);
  }

  static bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.physicalKey == PhysicalKeyboardKey.arrowLeft) {
        App().playboy.command(['seek', '-5']);
      } else if (event.physicalKey == PhysicalKeyboardKey.arrowRight) {
        App().playboy.command(['seek', '5']);
      } else if (event.physicalKey == PhysicalKeyboardKey.space) {
        App().playboy.playOrPause();
      } else if (event.physicalKey == PhysicalKeyboardKey.escape) {}
    }
    return false;
  }

  static bool enableKeyBinding = true;
  static Map<String, String> _keyBindings = {};

  static void _executeKeyAction(String key) {
    if (!_keyBindings.containsKey(key) || !enableKeyBinding) return;
    var actionName = _keyBindings[key];
    App().actions[actionName]?.call();
  }

  static void loadKeyBindings() async {
    var path = "${App().dataPath}/config/keybindings.json";
    var fp = File(path);
    if (!await fp.exists()) {
      await fp.create(recursive: true);
      var str = jsonEncode(_keyBindings);
      await fp.writeAsString(str);
    }
    Map<String, dynamic> data = jsonDecode(await fp.readAsString());
    _keyBindings = data.map((k, v) => MapEntry(k, v.toString()));
  }

  static void saveKeyBindings() async {
    var path = "${App().dataPath}/config/keybindings.json";
    var fp = File(path);
    var str = jsonEncode(_keyBindings);
    await fp.writeAsString(str);
  }

  static void addKeyBinding(String key, String action) {
    _keyBindings[key] = action;
  }

  static void removeKeyBinding(String key) {
    _keyBindings.remove(key);
  }
}
