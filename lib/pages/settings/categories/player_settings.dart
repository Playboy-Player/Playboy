import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '播放器'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            title: Text('自动开始播放'.l10n),
            value: AppStorage().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoPlay = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text('默认打开音乐视图'.l10n),
            value: AppStorage().settings.defaultMusicMode,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.defaultMusicMode = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text('记忆播放器状态'.l10n),
            subtitle: Text('音量和倍速'.l10n),
            value: AppStorage().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.rememberStatus = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text('退出播放页面后继续播放'.l10n),
            value: AppStorage().settings.playAfterExit,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.playAfterExit = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'MPV 参数'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '字幕'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
