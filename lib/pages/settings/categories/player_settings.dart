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
            value: AppStorage().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.autoPlay = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
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
                  'These options only apply on App start',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Custom Commands'.l10n,
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
