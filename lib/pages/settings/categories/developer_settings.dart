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
            title: const Text('Enable Tablet UI'),
            value: AppStorage().settings.tabletUI,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.tabletUI = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
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
