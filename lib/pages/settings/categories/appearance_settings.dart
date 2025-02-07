import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  final _controller1 = TextEditingController(); // primary font

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '字体'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            title: Text('显示字体'.l10n),
            subtitle: Text('留空以保持默认'.l10n),
            trailing: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _controller1,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: AppStorage().settings.font != ''
                      ? AppStorage().settings.font
                      : 'Default',
                ),
                onSubmitted: (value) {
                  _controller1.clear();
                  setState(() {
                    AppStorage().settings.font = value;
                  });
                  AppStorage().saveSettings();
                  AppStorage().updateStatus();
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '外观'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            title: Text('启动页面'.l10n),
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
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        const Icon(Icons.apps),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('播放列表'.l10n),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(Icons.smart_display_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('媒体库'.l10n),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.folder_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('文件'.l10n),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('搜索'.l10n),
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
          ListTile(
            title: Text('默认播放列表视图'.l10n),
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
                items: [
                  DropdownMenuItem(
                    value: false,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_view_month),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('网格'.l10n),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Row(
                      children: [
                        const Icon(Icons.view_agenda_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('列表'.l10n),
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
            title: Text('默认媒体库视图'.l10n),
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
                items: [
                  DropdownMenuItem(
                    value: false,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_view_month),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('网格'.l10n),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: true,
                    child: Row(
                      children: [
                        const Icon(Icons.view_agenda_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('列表'.l10n),
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
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '主题'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text('主题颜色'.l10n),
            trailing: SizedBox(
              height: 44,
              width: 150,
              child: DropdownButtonFormField(
                // icon: const SizedBox(),
                isExpanded: true,
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
                value: AppStorage().settings.themeCode,
                items: List.generate(
                  AppStorage().colors.length,
                  (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Row(
                        children: [
                          ColoredBox(
                            color: AppStorage().colors[index],
                            child: const SizedBox(
                              height: 16,
                              width: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(AppStorage().themes[index]),
                        ],
                      ),
                    );
                  },
                ),
                onChanged: (value) {
                  AppStorage().settings.themeCode = value!;
                  AppStorage().saveSettings();
                  AppStorage().updateStatus();
                },
              ),
            ),
          ),
          SwitchListTile(
            title: Text('使用系统主题'.l10n),
            value: AppStorage().settings.themeMode == ThemeMode.system,
            onChanged: (bool value) {
              if (value) {
                setState(
                  () {
                    AppStorage().settings.themeMode = ThemeMode.system;
                  },
                );
              } else {
                setState(
                  () {
                    AppStorage().settings.themeMode =
                        Theme.of(context).brightness == Brightness.dark
                            ? ThemeMode.dark
                            : ThemeMode.light;
                  },
                );
              }
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            },
          ),
          AppStorage().settings.themeMode == ThemeMode.system
              ? const SizedBox()
              : SwitchListTile(
                  title: Text('深色模式'.l10n),
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
        ],
      ),
    );
  }
}
