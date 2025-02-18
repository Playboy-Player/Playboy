import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => DeveloperSettingsState();
}

class DeveloperSettingsState extends State<DeveloperSettings> {
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
              'Developer Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            tileColor: AppStorage().settings.enableDevSettings
                ? colorScheme.primaryContainer
                : colorScheme.primaryContainer.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 40,
              child: const Text('Developer Setting'),
            ),
            value: AppStorage().settings.enableDevSettings,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableDevSettings = value;
              });
              AppStorage().saveSettings();
            },
          ),
          SwitchListTile(
            title: const Text('Enable Custom TitleBar'),
            value: AppStorage().settings.enableTitleBar,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableTitleBar = value;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            },
          ),
        ],
      ),
    );
  }
}
