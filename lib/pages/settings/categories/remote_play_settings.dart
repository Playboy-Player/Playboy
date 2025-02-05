import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class RemotePlaySettings extends StatefulWidget {
  const RemotePlaySettings({super.key});

  @override
  State<StatefulWidget> createState() => _RemotePlaySettingsState();
}

class _RemotePlaySettingsState extends State<RemotePlaySettings> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '远程播放设置',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            tileColor: AppStorage().settings.discoverable
                ? colorScheme.primaryContainer
                : colorScheme.primaryContainer.withValues(alpha: 0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: const Text('允许本设备接收局域网媒体'),
            ),
            value: AppStorage().settings.discoverable,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.discoverable = value;
              });
              AppStorage().saveSettings();
            },
          ),
        ],
      ),
    );
  }
}
