import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class DisplaySettingsPage extends StatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text("外观"),
        // ),
        body: ListView(
      children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: const Text('主题设置'),
        // ),
        // SwitchListTile(
        //     title: const Text('更鲜艳的背景颜色'),
        //     subtitle: const Text('仅浅色模式有效'),
        //     value: AppStorage().settings.enableBackgroundColor,
        //     onChanged: (bool value) {
        //       setState(() {
        //         AppStorage().settings.enableBackgroundColor = value;
        //       });
        //       AppStorage().saveSettings();
        //       AppStorage().updateStatus();
        //     }),
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            '主题模式',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        SwitchListTile(
            title: const Text('主题模式跟随系统'),
            value: AppStorage().settings.themeMode == ThemeMode.system,
            onChanged: (bool value) {
              if (value) {
                setState(() {
                  AppStorage().settings.themeMode = ThemeMode.system;
                });
              } else {
                setState(() {
                  AppStorage().settings.themeMode =
                      Theme.of(context).brightness == Brightness.dark
                          ? ThemeMode.dark
                          : ThemeMode.light;
                });
              }
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        AppStorage().settings.themeMode == ThemeMode.system
            ? const SizedBox()
            : SwitchListTile(
                title: const Text('启用深色模式'),
                value: AppStorage().settings.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      AppStorage().settings.themeMode = ThemeMode.dark;
                    });
                  } else {
                    setState(() {
                      AppStorage().settings.themeMode = ThemeMode.light;
                    });
                  }
                  AppStorage().saveSettings();
                  AppStorage().updateStatus();
                }),
        Container(
          padding: const EdgeInsets.all(12),
          child: const Text(
            '颜色',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        RadioListTile(
            title: const Text('Pink'),
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
            title: const Text('Red'),
            value: 1,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('Deep Purple'),
            value: 2,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('Indigo'),
            value: 3,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('Teal'),
            value: 4,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('Blue'),
            value: 5,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            }),
        RadioListTile(
            title: const Text('BlueGrey'),
            value: 6,
            groupValue: AppStorage().settings.themeCode,
            onChanged: (int? value) {
              setState(() {
                AppStorage().settings.themeCode = value!;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            })
      ],
    ));
  }
}

// enum ThemeColors{
//
// }
