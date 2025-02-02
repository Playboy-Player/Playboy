import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/l10n.dart';

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
            context.l10n.playSettings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        SwitchListTile(
            title: Text(context.l10n.autoPlayVideo),
            value: AppStorage().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoPlay = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.autoDownloadVideo),
            value: AppStorage().settings.autoDownload,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoDownload = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.defaultMusicView),
            value: AppStorage().settings.defaultMusicMode,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.defaultMusicMode = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.rememberPlayerStatus),
            subtitle: Text(context.l10n.volumeAndSpeed),
            value: AppStorage().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.rememberStatus = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.playInAppBackground),
            subtitle: Text(context.l10n.useMediaControlToStop),
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
            '播放器后端参数',
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
            '字幕设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    ));
  }
}
