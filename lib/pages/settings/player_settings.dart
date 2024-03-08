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
          child: const Text(
            '播放设置',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
            value: AppStorage().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.rememberStatus = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        // TODO: 退出时继续播放
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            '高级参数',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ));
  }
}
