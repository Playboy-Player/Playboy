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
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '界面',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SwitchListTile(
          title: const Text('启用波浪样式进度条'),
          subtitle: const Text('视频模式下无效'),
          value: AppStorage().settings.wavySlider,
          onChanged: (bool value) {
            setState(() {
              AppStorage().settings.wavySlider = value;
            });
            AppStorage().saveSettings();
            AppStorage().updateStatus();
          },
        ),
        SwitchListTile(
          title: const Text('启动时显示媒体控制卡片'),
          value: AppStorage().settings.showMediaCard,
          onChanged: (bool value) {
            setState(() {
              AppStorage().settings.showMediaCard = value;
            });
            AppStorage().saveSettings();
          },
        ),
        // TODO: ui settings
        // const ListTile(
        //   leading: Icon(Icons.home_filled),
        //   title: Text('初始页面'),
        // ),
        // const ListTile(
        //   title: Text('音乐库默认视图'),
        // ),
        // const ListTile(
        //   title: Text('视频库默认视图'),
        // ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '主题模式',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
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
                },
              ),
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '颜色',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
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
            title: const Text('Orange'),
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
            title: const Text('Amber'),
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
            title: const Text('Teal'),
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
            title: const Text('Blue'),
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
            title: const Text('Indigo'),
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
            title: const Text('Purple'),
            value: 6,
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

// enum ThemeColors{
//
// }
