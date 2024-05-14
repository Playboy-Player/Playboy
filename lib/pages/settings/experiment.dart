import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class ExperimentSettings extends StatefulWidget {
  const ExperimentSettings({super.key});

  @override
  State<ExperimentSettings> createState() => ExperimentSettingsState();
}

class ExperimentSettingsState extends State<ExperimentSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Dev Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable dev settings'),
            value: AppStorage().settings.enableDevSettings,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableDevSettings = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: const Text('Use try_look flag'),
            value: AppStorage().settings.tryLook,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.tryLook = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: const Text('Tablet UI'),
            value: AppStorage().settings.tabletUI,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.tabletUI = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
        ],
      ),
    );
  }
}
