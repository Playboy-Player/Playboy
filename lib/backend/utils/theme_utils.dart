import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';

MaterialColor getColorTheme() {
  return Colors.primaries[App().settings.themeCode];
}
