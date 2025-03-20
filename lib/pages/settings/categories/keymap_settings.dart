import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/widgets/settings_message_box.dart';
// import 'package:playboy/backend/storage.dart';
// import 'package:playboy/l10n/i10n.dart';

class KeymapSettings extends StatefulWidget {
  const KeymapSettings({super.key});

  @override
  State<StatefulWidget> createState() => _KeymapSettingsState();
}

class _KeymapSettingsState extends State<KeymapSettings> {
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
          SettingsMessageBox(message: '修改 input.conf 文件以自定义快捷键'.l10n),
        ],
      ),
    );
  }
}
