import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/settings_label.dart';
import 'package:playboy/widgets/settings_string_value.dart';

class LLMSettingsPage extends StatefulWidget {
  const LLMSettingsPage({super.key});

  @override
  State<LLMSettingsPage> createState() => LLMSettingsPageState();
}

class LLMSettingsPageState extends State<LLMSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'LLM'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SettingsLabel(label: 'base URL'.l10n),
          SettingsStringValue(
            hintText: App().settings.baseUrl,
            onSubmitted: (value) {
              setState(() {
                App().settings.baseUrl = value;
              });
              App().saveSettings();
            },
          ),
          SettingsLabel(label: 'LLM Name'.l10n),
          SettingsStringValue(
            hintText: App().settings.llmName,
            onSubmitted: (value) {
              setState(() {
                App().settings.llmName = value;
              });
              App().saveSettings();
            },
          ),
          SettingsLabel(label: 'API Key'.l10n),
          SettingsStringValue(
            hintText: App().settings.apiKey,
            onSubmitted: (value) {
              setState(() {
                App().settings.apiKey = value;
              });
              App().saveSettings();
            },
          ),
        ],
      ),
    );
  }
}
