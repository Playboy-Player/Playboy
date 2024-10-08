import 'package:flutter/material.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '显示语言 (未完成)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        RadioListTile(
            title: const Text('中文'),
            value: 0,
            groupValue: 0,
            onChanged: (int? value) {}),
        RadioListTile(
            title: const Text('English'),
            value: 1,
            groupValue: 0,
            onChanged: (int? value) {}),
      ],
    ));
  }
}
