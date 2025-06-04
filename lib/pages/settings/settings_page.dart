import 'package:flutter/material.dart';
import 'package:playboy/backend/keymap_helper.dart';
import 'package:playboy/backend/utils/theme_utils.dart';
import 'package:playboy/pages/settings/categories/llm_settings.dart';
import 'package:playboy/pages/settings/categories/whisper_settings.dart';

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
      const KeymapSettingsPage(),
    ),
    (
      Icons.auto_awesome_outlined,
      'LLM'.l10n,
      const LLMSettingsPage(),
    ),
    (
      Icons.hearing,
      'Whisper'.l10n,
      const WhisperSettingsPage(),
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
      const DeveloperSettingsPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    KeyMapHelper.keyBindinglock++;
  }

  @override
  void dispose() {
    super.dispose();
    KeyMapHelper.keyBindinglock--;
  }

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          Container(
            color: colorScheme.appBackground,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: _sidebarWidth,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 16,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '设置'.l10n,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildSettingsSideBar(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: colorScheme.appBackground,
              padding: const EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Container(
                  color: colorScheme.surface,
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 6,
                  ),
                  child: _tabs[_tabIndex].$3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSideBar() {
    late final colorScheme = Theme.of(context).colorScheme;
    Widget buildItem(int id, String name, IconData icon) {
      final bool selected = id == _tabIndex;
      return Material(
        color: selected ? colorScheme.secondary : colorScheme.appBackground,
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
