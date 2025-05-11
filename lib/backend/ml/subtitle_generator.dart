import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:playboy/backend/app.dart';
import 'package:whisper4dart/whisper4dart.dart' as whisper;

class SubtitleGenerator {
  bool initializing = false;
  late String modelnameString;
  late String modelDirectory;
  bool modelExists = false;
  late File modelFile;
  final String modelType;

  SubtitleGenerator(this.modelType) {
    init();
  }

  void init() {
    modelnameString = modelType;
    modelDirectory = '${App().dataPath}/models';
    modelFile = File(path.join(modelDirectory, modelnameString));
    Directory(modelDirectory).createSync(recursive: true);
    debugPrint("Model path: ${modelFile.path}");
  }

  Future<void> downloadModel({int failCount = 0}) async {
    // if (failCount > 3) {
    //   throw Exception("Failed to download model after 3 retries.");
    // }
    // var lock = Lock();
    // await lock.synchronized(() async {
    //   debugPrint("Downloading model...");

    //   var modelUri = Uri.parse(
    //       "https://hf-mirror.com/ggerganov/whisper.cpp/resolve/main/$modelnameString?download=true");

    //   Directory(modelDirectory).createSync(recursive: true);
    //   var response = await http.get(modelUri);
    //   if (response.statusCode == 200) {
    //     var file = File(path.join(modelDirectory, modelnameString));
    //     await file.writeAsBytes(response.bodyBytes);
    //     debugPrint('File downloaded and saved as $modelnameString');
    //     debugPrint("Model downloaded.");
    //   } else {
    //     debugPrint("Failed to download model, retrying...");
    //     await downloadModel(failCount: failCount + 1);
    //   }
    // });
  }

  void genSubtitle(
      String mediaPath, int currentTime, ValueNotifier<String> notifier) {
    var cparams = whisper.createContextDefaultParams();
    var whisperModel = whisper.Whisper(modelFile.path, cparams,
        outputMode: "srt", externalNotifier: notifier);
    whisperModel.inferIsolate(mediaPath,
        startTime: currentTime,
        useOriginalTime: true,
        newSegmentCallback: whisperModel.getSegmentCallback);
    whisperModel.free();
  }
}
