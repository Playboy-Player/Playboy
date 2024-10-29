import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';

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
            context.l10n.playback_settings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        SwitchListTile(
            title: Text(context.l10n.auto_play_video),
            value: AppStorage().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoPlay = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.auto_download_video),
            value: AppStorage().settings.autoDownload,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoDownload = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.default_music_mode),
            value: AppStorage().settings.defaultMusicMode,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.defaultMusicMode = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.remember_player_state),
            subtitle: Text(context.l10n.volume_and_speed),
            value: AppStorage().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.rememberStatus = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            }),
        SwitchListTile(
            title: Text(context.l10n.continue_play_after_exit),
            subtitle: Text(context.l10n.global_playback_control),
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
            context.l10n.mpv_settings,
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
