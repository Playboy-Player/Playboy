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
    Icons.account_circle_outlined,
    Icons.color_lens_outlined,
    Icons.play_circle_outline,
    Icons.folder_outlined,
    Icons.translate_rounded,
    Icons.info_outline,
    Icons.code
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
        // title: const Text(
        //   '设置',
        //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        // ),
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
        const SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 160,
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "设置",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )),
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
        color: selected ? colorScheme.secondary : null,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            setState(() {
              currentPage = id;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: selected ? colorScheme.onSecondary : null,
                  size: 22,
                ),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: selected ? colorScheme.onSecondary : null,
                    fontSize: 16,
                  ),
                )
              ],
            )),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: icons.length - (kDebugMode ? 0 : 1),
      itemBuilder: (context, index) =>
          buildItem(index, options[index], icons[index]),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 6,
        );
      },
    );
  }
}
