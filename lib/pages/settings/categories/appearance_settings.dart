import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/l10n.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  final TextEditingController _controller1 =
      TextEditingController(); // primary font
  final TextEditingController _controller2 =
      TextEditingController(); // secondary font

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '字体',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            title: const Text('首选字体'),
            subtitle: const Text('留空以保持默认'),
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
          ListTile(
            title: const Text('备用字体'),
            subtitle: const Text('默认为黑体(SimHei)'),
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
                controller: _controller2,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: AppStorage().settings.fallbackfont != ''
                      ? AppStorage().settings.fallbackfont
                      : "None",
                ),
                onSubmitted: (value) {
                  _controller2.clear();
                  setState(() {
                    AppStorage().settings.fallbackfont = value;
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
              context.l10n.appearance,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            title: Text(context.l10n.enableWavySlider),
            subtitle: Text(context.l10n.disabledInVideoPlaying),
            value: AppStorage().settings.wavySlider,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.wavySlider = value;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            },
          ),
          // SwitchListTile(
          //   title: const Text('应用内显示媒体控制卡片'),
          //   value: AppStorage().settings.showMediaCard,
          //   onChanged: (bool value) {
          //     setState(() {
          //       AppStorage().settings.showMediaCard = value;
          //     });
          //     AppStorage().saveSettings();
          //   },
          // ),
          ListTile(
            title: Text(context.l10n.startupPage),
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
                        Text(context.l10n.playlist),
                      ],
                    ),
                  ),
                  const DropdownMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.smart_display_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('媒体库'),
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
                        Text(context.l10n.files),
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
                        Text(context.l10n.search),
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
            title: Text(context.l10n.playlistDefaultView),
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
                        Text(context.l10n.grid),
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
                        Text(context.l10n.list),
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
          // ListTile(
          //   title: Text(context.l10n.musicLibraryDefaultView),
          //   trailing: SizedBox(
          //     height: 44,
          //     width: 150,
          //     child: DropdownButtonFormField(
          //       borderRadius: BorderRadius.circular(16),
          //       decoration: InputDecoration(
          //         isDense: true,
          //         filled: true,
          //         border: OutlineInputBorder(
          //           borderSide: const BorderSide(
          //             width: 0,
          //             style: BorderStyle.none,
          //           ),
          //           borderRadius: BorderRadius.circular(16),
          //         ),
          //         fillColor: Theme.of(context).colorScheme.secondaryContainer,
          //       ),
          //       value: AppStorage().settings.musicLibListview,
          //       items: [
          //         DropdownMenuItem(
          //           value: false,
          //           child: Row(
          //             children: [
          //               const Icon(Icons.calendar_view_month),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Text(context.l10n.grid),
          //             ],
          //           ),
          //         ),
          //         DropdownMenuItem(
          //           value: true,
          //           child: Row(
          //             children: [
          //               const Icon(Icons.view_agenda_outlined),
          //               const SizedBox(
          //                 width: 10,
          //               ),
          //               Text(context.l10n.list),
          //             ],
          //           ),
          //         ),
          //       ],
          //       onChanged: (value) {
          //         AppStorage().settings.musicLibListview = value!;
          //         AppStorage().saveSettings();
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 4,
          // ),
          ListTile(
            title: Text(context.l10n.videoLibraryDefaultView),
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
                        Text(context.l10n.grid),
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
                        Text(context.l10n.list),
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
              context.l10n.themeSettings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(context.l10n.themeColor),
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
                items: List.generate(AppStorage().colors.length, (index) {
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
                }),
                onChanged: (value) {
                  AppStorage().settings.themeCode = value!;
                  AppStorage().saveSettings();
                  AppStorage().updateStatus();
                },
              ),
            ),
          ),
          SwitchListTile(
            title: Text(context.l10n.themeModeFollowSystem),
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
            },
          ),
          AppStorage().settings.themeMode == ThemeMode.system
              ? const SizedBox()
              : SwitchListTile(
                  title: Text(context.l10n.enableDarkMode),
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
