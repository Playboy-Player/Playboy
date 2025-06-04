import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/settings_message_box.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:playboy/backend/storage.dart';
// import 'package:playboy/l10n/i10n.dart';

class KeymapSettingsPage extends StatefulWidget {
  const KeymapSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _KeymapSettingsPageState();
}

class _KeymapSettingsPageState extends State<KeymapSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              '快捷键'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          SettingsMessageBox(
            message: '修改 input.conf 文件以自定义快捷键'.l10n,
            trailing: TextButton(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/mpv-player/mpv/blob/master/etc/input.conf'),
                );
              },
              child: Text('示例'.l10n),
            ),
          ),
        ],
      ),
    );
  }
}
