import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class DeveloperSettingsPage extends StatefulWidget {
  const DeveloperSettingsPage({super.key});

  @override
  State<DeveloperSettingsPage> createState() => DeveloperSettingsPageState();
}

class DeveloperSettingsPageState extends State<DeveloperSettingsPage> {
  // final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '调试'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            tileColor: App().settings.enableDevSettings
                ? colorScheme.primaryContainer
                : colorScheme.primaryContainer.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: Text('启用调试选项'.l10n),
            ),
            value: App().settings.enableDevSettings,
            onChanged: (bool value) {
              setState(() {
                App().settings.enableDevSettings = value;
              });
              App().saveSettings();
            },
          ),
        ],
      ),
    );
  }
}
