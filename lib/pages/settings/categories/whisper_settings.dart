import 'package:flutter/material.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';

class WhisperSettingsPage extends StatefulWidget {
  const WhisperSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _WhisperSettingsPageState();
}

class _WhisperSettingsPageState extends State<WhisperSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Whisper'.l10n,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
