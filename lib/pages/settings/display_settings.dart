import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';

class DisplaySettingsPage extends StatefulWidget {
  const DisplaySettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _DisplaySettingsPageState();
}

class _DisplaySettingsPageState extends State<DisplaySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            context.l10n.interface_settings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        SwitchListTile(
          title: Text(context.l10n.enable_wave_style_progress_bar),
          subtitle: Text(context.l10n.video_mode_invalid),
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
          title: Text(context.l10n.initial_page),
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
                      Icon(Icons.web_stories_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(context.l10n.playlist),
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
                      Text(context.l10n.music),
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
                      Text(context.l10n.video),
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
                      Text(context.l10n.file),
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
          title: Text(context.l10n.playlist_default_view),
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
                      Icon(Icons.calendar_view_month),
                      SizedBox(
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
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
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
        ListTile(
          title: Text(context.l10n.music_library_default_view),
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
              items: [
                DropdownMenuItem(
                  value: false,
                  child: Row(
                    children: [
                      Icon(Icons.calendar_view_month),
                      SizedBox(
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
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(context.l10n.list),
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
          title: Text(context.l10n.video_library_default_view),
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
                      Icon(Icons.calendar_view_month),
                      SizedBox(
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
                      Icon(Icons.view_agenda_outlined),
                      SizedBox(
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
            context.l10n.theme_settings,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: Text(context.l10n.theme_color),
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
            title: Text(context.l10n.theme_mode_follow_system),
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
                title: Text(context.l10n.enable_dark_mode),
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
    ));
  }
}
