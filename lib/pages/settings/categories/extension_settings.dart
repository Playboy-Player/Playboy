import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class ExtensionSettings extends StatefulWidget {
  const ExtensionSettings({super.key});

  @override
  State<StatefulWidget> createState() => _ExtensionSettingsState();
}

class _ExtensionSettingsState extends State<ExtensionSettings> {
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
              '扩展功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            tileColor: AppStorage().settings.enableBvTools
                ? colorScheme.primaryContainer
                : colorScheme.primaryContainer.withValues(alpha: 0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: const Text('启用'),
            ),
            value: AppStorage().settings.enableBvTools,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableBvTools = value;
              });
              AppStorage().saveSettings();
            },
          ),
        ],
      ),
    );
  }
}
