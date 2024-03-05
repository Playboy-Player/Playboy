import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/web_helper.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'package:window_manager/window_manager.dart';
import 'package:media_kit/media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(400, 500),
    size: Size(900, 700),
    center: true,
    backgroundColor: Colors.transparent,
    // skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  MediaKit.ensureInitialized();

  AppStorage().init();
  await WebHelper().init();

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.transparent,
  //   systemNavigationBarDividerColor: Colors.transparent,
  //   statusBarColor: Colors.transparent,
  // ));

  runApp(
    ChangeNotifierProvider(
        create: (context) => AppStorage(), child: const MikuMiku()),
  );
}
