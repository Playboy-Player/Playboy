import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
// import 'package:playboy/backend/storage.dart';
// import 'package:playboy/l10n/i10n.dart';

class CommandSettings extends StatefulWidget {
  const CommandSettings({super.key});

  @override
  State<StatefulWidget> createState() => _CommandSettingsState();
}

class _CommandSettingsState extends State<CommandSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            '命令'.l10n,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    ));
  }
}
