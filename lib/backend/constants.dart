import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/maintainer.dart';

class Constants {
  static const IconData appIcon = Icons.smart_display;
  static const String appName = 'Playboy';
  static const String version = '2024.10';
  static const String flag = kDebugMode ? 'debug' : 'release';

  static List<Maintainer> maintainers = [
    Maintainer(
      avatar: 'res/maintainers/yui.jpg',
      name: 'YuiHrsw',
      url: 'https://github.com/YuiHrsw',
    )
  ];
}
