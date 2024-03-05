import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class LanguageSettinsPage extends StatefulWidget {
  const LanguageSettinsPage({super.key});

  @override
  State<StatefulWidget> createState() => _LanguageSettinsPageState();
}

class _LanguageSettinsPageState extends State<LanguageSettinsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            '语言',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        RadioListTile(
            title: const Text('中文'),
            value: 0,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('English'),
            value: 1,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
      ],
    ));
  }
}
