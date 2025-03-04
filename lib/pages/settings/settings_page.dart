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

typedef SettingsTab = (IconData, String, Widget);

class SettingsPageState extends State<SettingsPage> {
  int _tabIndex = 0;
  final double _sidebarWidth = 200;
  final List<SettingsTab> _tabs = [
    (
      Icons.color_lens_outlined,
      '外观'.l10n,
      const AppearanceSettingsPage(),
    ),
    (
      Icons.play_circle_outline,
      '播放器'.l10n,
      const PlayerSettingsPage(),
    ),
    (
      Icons.keyboard_command_key,
      '快捷键'.l10n,
      const KeymapSettings(),
    ),
    (
      Icons.folder_outlined,
      '存储'.l10n,
      const StorageSettingsPage(),
    ),
    (
      Icons.translate_rounded,
      '语言'.l10n,
      const LanguageSettingsPage(),
    ),
    (
      Icons.info_outline,
      '关于'.l10n,
      const AboutPage(),
    ),
    (
      Icons.bug_report_outlined,
      '调试'.l10n,
      const DeveloperSettings(),
    ),
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
        titleSpacing: 0,
        title: Stack(
          children: [
            Container(
              color: backgroundColor,
              width: _sidebarWidth,
              height: 40,
            ),
            IconButton(
              iconSize: 20,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
          IconButton(
            hoverColor: Colors.transparent,
            padding: EdgeInsets.zero,
            iconSize: 26,
            onPressed: () {
              windowManager.minimize();
            },
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
          IconButton(
            hoverColor: Colors.transparent,
            padding: EdgeInsets.zero,
            iconSize: 26,
            onPressed: () async {
              if (await windowManager.isMaximized()) {
                windowManager.unmaximize();
              } else {
                windowManager.maximize();
              }
            },
            icon: const Icon(Icons.keyboard_arrow_up),
          ),
          IconButton(
            hoverColor: Colors.transparent,
            iconSize: 20,
            onPressed: () {
              windowManager.close();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: _sidebarWidth,
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
                  child: _buildSettingsSideBar(),
                )
              ],
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _tabs[_tabIndex].$3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSideBar() {
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.04),
      colorScheme.surface,
    );
    Widget buildItem(int id, String name, IconData icon) {
      final bool selected = id == _tabIndex;
      return Material(
        color: selected ? colorScheme.secondary : backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _tabIndex = id;
            });
          },
          borderRadius: BorderRadius.circular(12),
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
      itemCount: _tabs.length,
      itemBuilder: (context, index) => buildItem(
        index,
        _tabs[index].$2,
        _tabs[index].$1,
      ),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 6,
        );
      },
    );
  }
}
