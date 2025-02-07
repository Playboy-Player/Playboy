import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:playboy/backend/storage.dart';

extension AppTranslation on String {
  String _translate() {
    var lang = AppStorage().settings.language;
    return (translations[lang]?[this]) ?? this;
  }

  String get l10n => _translate();

  static final Map<String, Map<String, String>> translations = {};

  static Future<void> init() async {
    var languages = jsonDecode(
      await rootBundle.loadString('l10n/manifest.json'),
    );

    for (var lang in languages) {
      var data = await rootBundle.loadString("l10n/$lang.json");
      Map<String, dynamic> translationData = jsonDecode(data);
      translations[lang] = translationData.map(
        (k, v) => MapEntry(k, v.toString()),
      );
    }
  }
}

extension ListTranslation on List<String> {
  List<String> _translate() {
    return List.generate(length, (index) => this[index].l10n);
  }

  List<String> get l10n => _translate();
}
