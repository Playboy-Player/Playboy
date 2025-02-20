import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
            value: App().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                App().settings.autoPlay = value;
              });
              App().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text('精确跳转'.l10n),
            value: App().settings.preciseSeek,
            onChanged: (bool value) {
              App().playboy.setProperty(
                    'hr-seek',
                    value ? 'yes' : 'no',
                  );
              setState(() {
                App().settings.preciseSeek = value;
              });
              App().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text('记忆播放器状态'.l10n),
            subtitle: Text('音量, 列表循环'.l10n),
            value: App().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                App().settings.rememberStatus = value;
              });
              App().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'MPV Properties'.l10n,
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
              'MPV Options'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: SizedBox(
              height: 50,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '重启应用后生效',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
