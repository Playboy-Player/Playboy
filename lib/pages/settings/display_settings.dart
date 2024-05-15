import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';

class DisplaySettingsPage extends StatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _DisplaySettingsPageState();
}

// TODO: fullscreen scaling settings
class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '界面设置',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
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
          title: const Text('应用内显示媒体控制卡片'),
          value: AppStorage().settings.showMediaCard,
          onChanged: (bool value) {
            setState(() {
              AppStorage().settings.showMediaCard = value;
            });
            AppStorage().saveSettings();
          },
        ),
        // TODO: ui settings
        ListTile(
          title: const Text('初始页面'),
          trailing: SizedBox(
            height: 44,
            width: 150,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(16),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              value: AppStorage().settings.initPage,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Icon(Icons.web_stories_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('播放列表'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.music_note_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('音乐'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.movie_filter_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('视频'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.folder_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('文件'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 10,
                      ),
                      Text('搜索'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                AppStorage().settings.initPage = value!;
                AppStorage().saveSettings();
              },
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        // TODO: use segment button
        ListTile(
          title: const Text('播放列表默认视图'),
          trailing: SizedBox(
            height: 44,
            width: 150,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(16),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              value: AppStorage().settings.playlistListview,
              items: const [
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_view_month),
                      SizedBox(
                        width: 10,
                      ),
                      Text('网格'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('列表'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                AppStorage().settings.playlistListview = value!;
                AppStorage().saveSettings();
              },
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        ListTile(
          title: const Text('音乐库默认视图'),
          trailing: SizedBox(
            height: 44,
            width: 150,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(16),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              value: AppStorage().settings.musicLibListview,
              items: const [
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_view_month),
                      SizedBox(
                        width: 10,
                      ),
                      Text('网格'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('列表'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                AppStorage().settings.musicLibListview = value!;
                AppStorage().saveSettings();
              },
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        ListTile(
          title: const Text('视频库默认视图'),
          trailing: SizedBox(
            height: 44,
            width: 150,
            child: DropdownButtonFormField(
              borderRadius: BorderRadius.circular(16),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
              value: AppStorage().settings.videoLibListview,
              items: const [
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_view_month),
                      SizedBox(
                        width: 10,
                      ),
                      Text('网格'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: true,
                  child: Row(
                    children: [
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text('列表'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                AppStorage().settings.videoLibListview = value!;
                AppStorage().saveSettings();
              },
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
            '主题颜色',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
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
