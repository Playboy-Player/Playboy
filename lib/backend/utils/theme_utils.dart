import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';

MaterialColor getColorTheme() {
  return Colors.primaries[App().settings.themeCode];
}

ThemeData getThemeData(App value, ColorScheme colorScheme) {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    ),
    fontFamily: value.settings.font != '' ? value.settings.font : null,
    fontFamilyFallback: Platform.isWindows ? ['Microsoft YaHei UI'] : null,
    colorScheme: colorScheme,
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: TextStyle(
        color: colorScheme.onSecondary,
        fontWeight: FontWeight.w500,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      barrierColor: colorScheme.surfaceTint.withValues(alpha: 0.1),
      shadowColor: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: colorScheme.appBackground,
      indicatorColor: colorScheme.primaryContainer,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(22),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      // ignore: deprecated_member_use
      year2023: false,
      trackHeight: 4,
      thumbSize: const WidgetStatePropertyAll(Size(4, 12)),
      overlayShape: SliderComponentShape.noOverlay,
    ),
  );
}

extension ThemeUtils on ColorScheme {
  Color get appBackground => Color.alphaBlend(
        primary.withValues(alpha: 0.04),
        surface,
      );

  Color get actionHoverColor => Color.alphaBlend(
        primary.withValues(alpha: 0.08),
        surface,
      );
}
