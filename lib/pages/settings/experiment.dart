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
              '实验性功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('启用 try_look 标识'),
            value: AppStorage().settings.tryLook,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.tryLook = value;
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
