import 'package:flutter/services.dart';
import 'package:playboy/backend/app.dart';

import 'package:playboy/backend/actions.dart' as actions;

class KeyMapHelper {
  static late final HardwareKeyboard _keyboard;
  static void init() {
    // loadKeyBindings();
    _keyboard = ServicesBinding.instance.keyboard;
    _keyboard.addHandler(_handleKeyEvent);
  }

  static bool _handleKeyEvent(KeyEvent e) {
    if (e is KeyDownEvent) {
      String key = '';
      if (e.physicalKey == PhysicalKeyboardKey.keyA) key = 'a';
      if (e.physicalKey == PhysicalKeyboardKey.keyB) key = 'b';
      if (e.physicalKey == PhysicalKeyboardKey.keyC) key = 'c';
      if (e.physicalKey == PhysicalKeyboardKey.keyD) key = 'd';
      if (e.physicalKey == PhysicalKeyboardKey.keyE) key = 'e';
      if (e.physicalKey == PhysicalKeyboardKey.keyF) key = 'f';
      if (e.physicalKey == PhysicalKeyboardKey.keyG) key = 'g';
      if (e.physicalKey == PhysicalKeyboardKey.keyH) key = 'h';
      if (e.physicalKey == PhysicalKeyboardKey.keyI) key = 'i';
      if (e.physicalKey == PhysicalKeyboardKey.keyJ) key = 'j';
      if (e.physicalKey == PhysicalKeyboardKey.keyK) key = 'k';
      if (e.physicalKey == PhysicalKeyboardKey.keyL) key = 'l';
      if (e.physicalKey == PhysicalKeyboardKey.keyM) key = 'm';
      if (e.physicalKey == PhysicalKeyboardKey.keyN) key = 'n';
      if (e.physicalKey == PhysicalKeyboardKey.keyO) key = 'o';
      if (e.physicalKey == PhysicalKeyboardKey.keyP) key = 'p';
      if (e.physicalKey == PhysicalKeyboardKey.keyQ) key = 'q';
      if (e.physicalKey == PhysicalKeyboardKey.keyR) key = 'r';
      if (e.physicalKey == PhysicalKeyboardKey.keyS) key = 's';
      if (e.physicalKey == PhysicalKeyboardKey.keyT) key = 't';
      if (e.physicalKey == PhysicalKeyboardKey.keyU) key = 'u';
      if (e.physicalKey == PhysicalKeyboardKey.keyV) key = 'v';
      if (e.physicalKey == PhysicalKeyboardKey.keyW) key = 'w';
      if (e.physicalKey == PhysicalKeyboardKey.keyX) key = 'x';
      if (e.physicalKey == PhysicalKeyboardKey.keyY) key = 'y';
      if (e.physicalKey == PhysicalKeyboardKey.keyZ) key = 'z';

      if (e.physicalKey == PhysicalKeyboardKey.digit0) key = '0';
      if (e.physicalKey == PhysicalKeyboardKey.digit1) key = '1';
      if (e.physicalKey == PhysicalKeyboardKey.digit2) key = '2';
      if (e.physicalKey == PhysicalKeyboardKey.digit3) key = '3';
      if (e.physicalKey == PhysicalKeyboardKey.digit4) key = '4';
      if (e.physicalKey == PhysicalKeyboardKey.digit5) key = '5';
      if (e.physicalKey == PhysicalKeyboardKey.digit6) key = '6';
      if (e.physicalKey == PhysicalKeyboardKey.digit7) key = '7';
      if (e.physicalKey == PhysicalKeyboardKey.digit8) key = '8';
      if (e.physicalKey == PhysicalKeyboardKey.digit9) key = '9';

      if (e.physicalKey == PhysicalKeyboardKey.f1) key = 'F1';
      if (e.physicalKey == PhysicalKeyboardKey.f2) key = 'F2';
      if (e.physicalKey == PhysicalKeyboardKey.f3) key = 'F3';
      if (e.physicalKey == PhysicalKeyboardKey.f4) key = 'F4';
      if (e.physicalKey == PhysicalKeyboardKey.f5) key = 'F5';
      if (e.physicalKey == PhysicalKeyboardKey.f6) key = 'F6';
      if (e.physicalKey == PhysicalKeyboardKey.f7) key = 'F7';
      if (e.physicalKey == PhysicalKeyboardKey.f8) key = 'F8';
      if (e.physicalKey == PhysicalKeyboardKey.f9) key = 'F9';
      if (e.physicalKey == PhysicalKeyboardKey.f10) key = 'F10';
      if (e.physicalKey == PhysicalKeyboardKey.f11) key = 'F11';
      if (e.physicalKey == PhysicalKeyboardKey.f12) key = 'F12';

      if (e.physicalKey == PhysicalKeyboardKey.space) key = 'SPACE';
      if (e.physicalKey == PhysicalKeyboardKey.escape) key = 'ESC';
      if (e.physicalKey == PhysicalKeyboardKey.arrowDown) key = 'DOWN';
      if (e.physicalKey == PhysicalKeyboardKey.arrowLeft) key = 'LEFT';
      if (e.physicalKey == PhysicalKeyboardKey.arrowRight) key = 'RIGHT';
      if (e.physicalKey == PhysicalKeyboardKey.arrowUp) key = 'UP';

      if (_keyboard.isAltPressed) key = 'ALT+$key';
      if (_keyboard.isShiftPressed) key = 'SHIFT+$key';
      if (_keyboard.isControlPressed) key = 'CTRL+$key';
      if (_keyboard.isMetaPressed) key = 'META+$key';

      if (enableKeyBinding) {
        if (_keyBindings.containsKey(key)) {
          // overrides mpv keymap
          _executeKeyAction(key);
        } else {
          // use keymap from mpv builtin and user input.conf
          App().playboy.command(['keypress', key]);
        }
      }
    }
    return false;
  }

  static bool enableKeyBinding = true;
  static final Map<String, String> _keyBindings = {
    'q': actions.togglePlayer,
    'Q': actions.togglePlayer,
    'f': actions.toggleFullscreen,
  };

  static void _executeKeyAction(String key) {
    if (!_keyBindings.containsKey(key)) return;
    var actionName = _keyBindings[key];
    App().actions[actionName]?.call();
  }

  // static void loadKeyBindings() async {
  //   var path = "${App().dataPath}/config/keybindings.json";
  //   var fp = File(path);
  //   if (!await fp.exists()) {
  //     await fp.create(recursive: true);
  //     var str = jsonEncode(_keyBindings);
  //     await fp.writeAsString(str);
  //   }
  //   Map<String, dynamic> data = jsonDecode(await fp.readAsString());
  //   _keyBindings = data.map((k, v) => MapEntry(k, v.toString()));
  // }

  // static void saveKeyBindings() async {
  //   var path = "${App().dataPath}/config/keybindings.json";
  //   var fp = File(path);
  //   var str = jsonEncode(_keyBindings);
  //   await fp.writeAsString(str);
  // }

  // static void addKeyBinding(String key, String action) {
  //   _keyBindings[key] = action;
  // }

  // static void removeKeyBinding(String key) {
  //   _keyBindings.remove(key);
  // }
}
