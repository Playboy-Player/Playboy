import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/path_setting_card.dart';
import 'package:playboy/widgets/settings_message_box.dart';
import 'package:url_launcher/url_launcher.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  final TextEditingController _volumeEditor = TextEditingController();
  final TextEditingController _speedEditor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '播放器'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SwitchListTile(
            title: Text('自动开始播放'.l10n),
            value: App().settings.autoPlay,
            onChanged: (bool value) {
              setState(() {
                App().settings.autoPlay = value;
              });
              App().saveSettings();
            },
          ),
          SwitchListTile(
            title: Text('记忆播放器状态'.l10n),
            subtitle: Text('音量, 列表循环'.l10n),
            value: App().settings.rememberStatus,
            onChanged: (bool value) {
              setState(() {
                App().settings.rememberStatus = value;
              });
              App().saveSettings();
            },
          ),
          // default playlist mode
          ListTile(
            title: Text('默认音量'.l10n),
            trailing: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.4),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _volumeEditor,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: App().settings.defaultVolume.toString(),
                ),
                onSubmitted: (value) {
                  var newVolume = double.tryParse(value);
                  if (newVolume == null || newVolume < 0 || newVolume > 100) {
                    _volumeEditor.clear();
                    return;
                  }
                  App().settings.defaultVolume = newVolume;
                  App().saveSettings();
                  setState(() {});
                  _volumeEditor.clear();
                },
              ),
            ),
          ),
          ListTile(
            title: Text('默认倍速'.l10n),
            trailing: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.4),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _speedEditor,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: App().settings.defaultSpeed.toString(),
                ),
                onSubmitted: (value) {
                  var newSpeed = double.tryParse(value);
                  if (newSpeed == null || newSpeed < 0.01 || newSpeed > 16) {
                    _speedEditor.clear();
                    return;
                  }
                  App().settings.defaultSpeed = newSpeed;
                  App().saveSettings();
                  setState(() {});
                  _speedEditor.clear();
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'libmpv 设置'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SettingsMessageBox(message: '注意: libmpv 设置需要重启应用才能生效'.l10n),
          const SizedBox(height: 6),
          // osd level 0123
          SwitchListTile(
            title: Text('允许 libmpv 使用配置文件'.l10n),
            value: App().settings.enableMpvConfig,
            onChanged: (value) {
              setState(() {
                App().settings.enableMpvConfig = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('使用 libmpv 预置键位绑定'.l10n),
            value: App().settings.useDefaultKeyBinding,
            onChanged: (value) {
              setState(() {
                App().settings.useDefaultKeyBinding = value;
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'mpv 配置文件路径'.l10n,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PathSettingCard(
            path: App().settings.mpvConfigPath != ''
                ? App().settings.mpvConfigPath
                : App().dataPath,
            actions: [
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: () {
                    launchUrl(
                      Uri.directory(
                        App().settings.mpvConfigPath != ''
                            ? App().settings.mpvConfigPath
                            : App().dataPath,
                      ),
                    );
                  },
                  icon: const Icon(Icons.folder_outlined),
                ),
              ),
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: () async {
                    var res = await FilePicker.platform
                        .getDirectoryPath(lockParentWindow: true);
                    if (res != null) {
                      App().settings.mpvConfigPath = res;
                      App().saveSettings();
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
            ],
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //   child: Text(
          //     'mpv 动态库路径'.l10n,
          //     style: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          // PathSettingCard(
          //   path: App().settings.libmpvPath,
          //   actions: [
          //     SizedBox(
          //       width: 40,
          //       child: IconButton(
          //         onPressed: () async {
          //           var res = await FilePicker.platform
          //               .getDirectoryPath(lockParentWindow: true);
          //           if (res != null) {
          //             App().settings.libmpvPath = res;
          //             App().saveSettings();
          //             setState(() {});
          //           }
          //         },
          //         icon: const Icon(Icons.edit_outlined),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
