import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:playboy/backend/app.dart';
import 'package:playboy/backend/ml/whisper_model_list.dart';
import 'package:playboy/backend/utils/l10n_utils.dart';
import 'package:playboy/backend/utils/sliver_utils.dart';
import 'package:playboy/widgets/settings_path_card.dart';
import 'package:playboy/widgets/settings_label.dart';
import 'package:playboy/widgets/settings_message_box.dart';
import 'package:url_launcher/url_launcher.dart';

class WhisperSettingsPage extends StatefulWidget {
  const WhisperSettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _WhisperSettingsPageState();
}

class _WhisperSettingsPageState extends State<WhisperSettingsPage> {
  String _errorMessage = '';
  final List<String> _modelFiles = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    try {
      var dir = Directory('${App().dataPath}/models');
      if (!await dir.exists()) {
        await dir.create();
      }
      await for (var item in dir.list()) {
        if (item is File && extension(item.path) == '.bin') {
          _modelFiles.add(basename(item.path));
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
          ).toSliver(),
          SliverToBoxAdapter(
            child: ListTile(
              onTap: () {
                launchUrl(Uri.directory('${App().dataPath}/models'));
              },
              leading: const Icon(Icons.folder_outlined),
              title: Text('打开模型文件夹'.l10n),
              subtitle: Text(
                normalize('${App().dataPath}/models'),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SettingsLabel(label: '本地模型'.l10n).toSliver(),
          SettingsMessageBox(message: '当前使用模型: ${App().settings.model}')
              .toSliver(),
          const SizedBox(height: 6).toSliver(),
          _errorMessage != ''
              ? SettingsMessageBox(message: 'ERROR: $_errorMessage').toSliver()
              : SliverList.builder(
                  itemBuilder: (context, index) {
                    return SettingsPath(
                      path: _modelFiles[index],
                      actions: [
                        App().settings.model == _modelFiles[index]
                            ? const SizedBox(
                                width: 40,
                                child: Icon(Icons.check_circle_outline),
                              )
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    App().settings.model = _modelFiles[index];
                                    App().saveSettings();
                                  });
                                },
                                child: Text(
                                  '选择'.l10n,
                                ),
                              ),
                      ],
                    );
                  },
                  itemCount: _modelFiles.length,
                ),
          SettingsLabel(label: '从 Hugging Face 下载'.l10n).toSliver(),
          SwitchListTile(
            title: Text('使用镜像链接'.l10n),
            value: App().settings.useMirrorLink,
            onChanged: (value) {
              setState(() {
                App().settings.useMirrorLink = value;
              });
            },
          ).toSliver(),
          SliverList.builder(
            itemBuilder: (context, index) {
              return SettingsPath(
                path: models[index].name,
                actions: [
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        if (App().settings.useMirrorLink) {
                          launchUrl(Uri.parse(modelsMirror[index].link));
                        } else {
                          launchUrl(Uri.parse(models[index].link));
                        }
                      },
                      icon: const Icon(Icons.file_download_outlined),
                    ),
                  ),
                ],
              );
            },
            itemCount: models.length,
          ),
        ],
      ),
    );
  }
}
