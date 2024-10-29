import 'package:flutter/material.dart';
import 'package:playboy/backend/storage.dart';
import 'package:playboy/l10n/i10n.dart';

class DeveloperSettings extends StatefulWidget {
  const DeveloperSettings({super.key});

  @override
  State<DeveloperSettings> createState() => DeveloperSettingsState();
}

class DeveloperSettingsState extends State<DeveloperSettings> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.developer_settings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.refresh),
          //   title: const Text('call setState'),
          //   onTap: () {
          //     setState(() {});
          //   },
          // ),
          SwitchListTile(
            title: Text(context.l10n.enable_tablet_ui),
            value: AppStorage().settings.tabletUI,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.tabletUI = value;
              });
              AppStorage().saveSettings();
              // AppStorage().updateStatus();
            },
          ),
          SwitchListTile(
            title: Text(context.l10n.enable_custom_title_bar),
            value: AppStorage().settings.enableTitleBar,
            onChanged: (bool value) {
              setState(() {
                AppStorage().settings.enableTitleBar = value;
              });
              AppStorage().saveSettings();
              AppStorage().updateStatus();
            },
          ),
          ListTile(
            leading: const Icon(Icons.height),
            title: Text(context.l10n.title_bar_offset),
            subtitle: Text(context.l10n.base),
            trailing: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _controller,
                maxLines: 1,
                decoration: InputDecoration.collapsed(
                  hintText: AppStorage().settings.titleBarOffset.toString(),
                ),
                onSubmitted: (value) {
                  var newOffset = double.tryParse(value);
                  if (newOffset == null || newOffset < 0) {
                    _controller.clear();
                    return;
                  }
                  AppStorage().settings.titleBarOffset = newOffset;
                  AppStorage().saveSettings();
                  setState(() {});
                  _controller.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
