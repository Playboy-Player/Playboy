import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/models/maintainer.dart';

class Constants {
  static const IconData appIcon = Icons.smart_display;
  static const String appName = 'Playboy';
  static const String version = '2025.1';
  static const String flag = kDebugMode ? 'debug' : 'release';

  static List<Contributor> maintainers = [
    Contributor(
      avatar: 'res/contributors/yui.jpg',
      name: 'YuiHrsw',
      url: 'https://github.com/YuiHrsw',
    ),
    Contributor(
      avatar: 'res/contributors/KernelInterrupt.jpg',
      name: 'KernelInterrupt',
      url: 'https://github.com/KernelInterrupt',
    ),
    Contributor(
      avatar: 'res/contributors/rubbrt.jpg',
      name: 'rubbrt',
      url: 'https://github.com/rubbrt',
    )
  ];
}
