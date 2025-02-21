import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playboy/backend/keymap_helper.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';
import 'package:macos_window_utils/macos_window_utils.dart';

import 'package:playboy/backend/library_helper.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/pages/home.dart';

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await App().init();
  await L10n.init();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      minimumSize: const Size(360, 500),
      // size: const Size(900, 700),
      center: true,
      backgroundColor: Colors.transparent,
      titleBarStyle: App().settings.enableTitleBar
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      // await windowManager.setHasShadow(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // set auto hide toolbar to fix window_manager bug on macOS
  if (Platform.isMacOS) {
    await WindowManipulator.initialize(enableWindowDelegate: true);

    final options = NSAppPresentationOptions.from({
      NSAppPresentationOption.fullScreen,
      NSAppPresentationOption.autoHideToolbar,
      NSAppPresentationOption.autoHideMenuBar,
      NSAppPresentationOption.autoHideDock,
    });

    options.applyAsFullScreenPresentationOptions();
  }

  // if (Platform.isAndroid) {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       systemNavigationBarColor: Colors.transparent,
  //       systemNavigationBarDividerColor: Colors.transparent,
  //       statusBarColor: Colors.transparent,
  //     ),
  //   );
  // }

  // ServicesBinding.instance.keyboard.addHandler(KeyMapHelper.handleKeyEvent);
  KeyMapHelper.init();

  if (arguments.isNotEmpty) {
    String mediaToOpen = arguments[0];
    App().openMedia(await LibraryHelper.getItemFromFile(mediaToOpen));
    runApp(const HomePage(playerView: true));
  } else {
    runApp(const HomePage());
  }
}
