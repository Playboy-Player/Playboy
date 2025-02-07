import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/pages/settings/categories/about_app_settings.dart';
import 'package:playboy/pages/settings/categories/appearance_settings.dart';
import 'package:playboy/pages/settings/categories/keymap_settings.dart';
import 'package:playboy/pages/settings/categories/language_settings.dart';
import 'package:playboy/pages/settings/categories/player_settings.dart';
import 'package:playboy/pages/settings/categories/storage_settings.dart';
import 'package:playboy/pages/settings/categories/developer_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  int _currentPage = 0;
  final double _sizebarWidth = 200;
  final List<IconData> _icons = [
    Icons.color_lens_outlined,
    Icons.play_circle_outline,
    Icons.keyboard_command_key,
    Icons.folder_outlined,
    Icons.translate_rounded,
    Icons.info_outline,
    Icons.bug_report_outlined,
  ];
  final List<Widget> _pages = [
    const AppearanceSettingsPage(),
    const PlayerSettingsPage(),
    const KeymapSettings(),
    const StorageSettingsPage(),
    const LanguageSettingsPage(),
    const AboutPage(),
    const DeveloperSettings(),
  ];
  final List<String> _options = [
    '外观'.l10n,
    '播放器'.l10n,
    '快捷键'.l10n,
    '存储'.l10n,
    '语言'.l10n,
    '关于'.l10n,
    '调试'.l10n,
  ];

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        automaticallyImplyLeading: false,
        leading: Platform.isMacOS
            ? null
            : IconButton(
                iconSize: 20,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              color: backgroundColor,
              width: _sizebarWidth - (Platform.isMacOS ? 0 : 40),
              height: 40,
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        flexibleSpace: Column(
          children: [
            SizedBox(
              height: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUp,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (details) {
                    windowManager.startResizing(ResizeEdge.top);
                  },
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) {
                  windowManager.startDragging();
                },
              ),
            )
          ],
        ),
        toolbarHeight: 40,
        actions: [
          if (!Platform.isMacOS)
            IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () {
                windowManager.minimize();
              },
              icon: const Icon(Icons.minimize),
            ),
          if (!Platform.isMacOS)
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
              icon: const Icon(Icons.crop_square),
            ),
          if (!Platform.isMacOS)
            IconButton(
              hoverColor: Colors.transparent,
              iconSize: 20,
              onPressed: () {
                windowManager.close();
              },
              icon: const Icon(Icons.close),
            ),
          if (Platform.isMacOS)
            IconButton(
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          if (Platform.isMacOS) const SizedBox(width: 8)
        ],
      ),
      body: Row(
        children: [
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: _sizebarWidth,
            child: Column(
              children: [
                if (Platform.isAndroid) const SizedBox(height: 40),
                Container(
                  alignment: Alignment.topCenter,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '设置'.l10n,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildSettingsSideBar(_options),
                )
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _pages[_currentPage],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSideBar(List<String> options) {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    Widget buildItem(int id, String name, IconData icon) {
      final bool selected = id == _currentPage;
      return Material(
        color: selected ? colorScheme.secondary : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _currentPage = id;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 40,
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
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: _icons.length,
      itemBuilder: (context, index) => buildItem(
        index,
        options[index],
        _icons[index],
      ),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 6,
        );
      },
    );
  }
}
