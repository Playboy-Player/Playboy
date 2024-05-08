import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:playboy/pages/settings/about_app.dart';
import 'package:playboy/pages/settings/account_setting.dart';
import 'package:playboy/pages/settings/display_settings.dart';
import 'package:playboy/pages/settings/language_settings.dart';
import 'package:playboy/pages/settings/player_settings.dart';
import 'package:playboy/pages/settings/storage_settings.dart';
import 'package:playboy/pages/settings/experiment.dart';
import 'package:window_manager/window_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

// TODO: mobile settings ui
class SettingsPageState extends State<SettingsPage> {
  int currentPage = 0;
  List<IconData> icons = [
    Icons.account_circle,
    Icons.color_lens,
    Icons.play_circle_rounded,
    Icons.folder,
    Icons.translate_rounded,
    Icons.info,
    Icons.construction_rounded
  ];
  List<String> options = [
    '账号',
    '外观',
    '播放器',
    '文件',
    '语言',
    '关于',
    '测试',
  ];
  List<Widget> pages = [
    const AccountSettingsPage(),
    const DisplaySettingsPage(),
    const PlayerSettingsPage(),
    const StorageSettingsPage(),
    const LanguageSettinsPage(),
    const AboutPage(),
    const ExperimentSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    // late final colorScheme = Theme.of(context).colorScheme;
    // late final backgroundColor = Color.alphaBlend(
    //     colorScheme.primary.withOpacity(0.08), colorScheme.surface);
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     hoverColor: Colors.transparent,
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Symbols.home)),
        scrolledUnderElevation: 0,
        // automaticallyImplyLeading: false,
        // backgroundColor: backgroundColor,
        flexibleSpace: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            windowManager.startDragging();
          },
        ),
        toolbarHeight: 40,
        title: const Text(
          '设置',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          // IconButton(
          //     hoverColor: Colors.transparent,
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     icon: const Icon(Symbols.home)),
          IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () {
                windowManager.minimize();
              },
              icon: const Icon(Icons.minimize)),
          IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () async {
                if (await windowManager.isMaximized()) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
              },
              icon: const Icon(Icons.crop_square)),
          IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () {
                windowManager.close();
              },
              icon: const Icon(Icons.close)),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: Row(children: [
        SizedBox(
            width: 180,
            child: Column(
              children: [
                // Container(
                //     alignment: Alignment.centerLeft,
                //     height: 70,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: const Text(
                //       "设置",
                //       style:
                //           TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                //     )),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: buildSettings(),
                )
              ],
            )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: pages[currentPage],
        )),
      ]),
      // floatingActionButton: FloatingActionButton(
      //     heroTag: 'settings',
      //     backgroundColor: colorScheme.onTertiary,
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Icon(Icons.home_filled)),
    );
  }

  Widget buildSettings() {
    late final colorScheme = Theme.of(context).colorScheme;
    Widget buildItem(int id, String name, IconData icon) {
      final bool selected = id == currentPage;
      return Material(
        color: selected ? colorScheme.secondaryContainer : null,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
        child: InkWell(
          onTap: () {
            setState(() {
              currentPage = id;
            });
          },
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(18), bottomRight: Radius.circular(18)),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 26,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                )
              ],
            )),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: icons.length - (kDebugMode ? 0 : 1),
      itemBuilder: (context, index) =>
          buildItem(index, options[index], icons[index]),
    );
  }
}
