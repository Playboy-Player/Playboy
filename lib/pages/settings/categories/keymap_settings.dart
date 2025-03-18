import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
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
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
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
          Container(
            decoration: ShapeDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: SizedBox(
              height: 50,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '修改 input.conf 文件以自定义快捷键, 请确保开启了允许 libmpv 使用配置文件的选项',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
