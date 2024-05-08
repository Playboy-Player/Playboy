import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

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
            '播放设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SwitchListTile(
            title: const Text('自动播放视频'),
            value: AppStorage().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoPlay = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: const Text('自动下载视频'),
            value: AppStorage().settings.autoDownload,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoDownload = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: const Text('默认音乐模式'),
            value: AppStorage().settings.defaultMusicMode,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.defaultMusicMode = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: const Text('记忆播放器状态'),
            subtitle: const Text('音量和倍速'),
            value: AppStorage().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.rememberStatus = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: const Text('退出播放界面后继续播放'),
            subtitle: const Text('可通过全局播放控件停止'),
            value: AppStorage().settings.playAfterExit,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.playAfterExit = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            'mpv 设置 (未完成)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    ));
  }
}
