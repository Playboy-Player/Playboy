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
            },
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'libmpv 设置'.l10n,
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
                  '注意: libmpv 设置需要重启应用才能生效',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SwitchListTile(
            title: Text('允许 libmpv 使用配置文件'.l10n),
            value: true,
            onChanged: (bool value) {},
          ),
          SwitchListTile(
            title: Text('使用 libmpv 预置键位绑定'.l10n),
            value: true,
            onChanged: (bool value) {},
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'mpv 配置文件路径'.l10n,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'osd-level'.l10n,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
