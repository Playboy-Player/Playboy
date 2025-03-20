import 'dart:async';
import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart' as path;
// import 'package:http/http.dart' as http;
// import 'package:playboy/backend/app.dart';
import 'package:whisper4dart/whisper4dart.dart' as whisper;
// import 'package:synchronized/synchronized.dart';

class SubtitleGenerator {
  // bool _isInitialized = false;
  bool initializing = false;
  final Completer<void> _initializerCompleter = Completer<void>.sync();
  late String modelnameString;
  late String modelDirectory;
  bool modelExists = false;
  late File modelFile;
  final String modelType;

  SubtitleGenerator(this.modelType) {
    init();
  }

  void ensureInitialized() async {
    await _initializerCompleter.future;
    return;
  }

  Future<void> init() async {
    // if (initializing) {
    //   await _initializerCompleter.future;
    // }
    // initializing = true;

    // var lock = Lock();
    // try {
    //   await lock.synchronized(() async {
    //     modelnameString = "ggml-$modelType.bin";
    //     modelDirectory = '${App().dataPath}/models';
    //     modelFile = File(path.join(modelDirectory, modelnameString));
    //     Directory(modelDirectory).createSync(recursive: true);
    //     debugPrint("Model path: ${modelFile.path}");
    //     modelExists = modelFile.existsSync();
    //     _isInitialized = modelExists;
    //     if (modelExists) {
    //       _initializerCompleter.complete();
    //     }
    //     if (!modelExists) {
    //       var lock = Lock();
    //       await lock.synchronized(() async {
    //         await downloadModel();
    //       });
    //     }
    //   });
    // } catch (e) {
    //   rethrow;
    // } finally {
    //   initializing = false;
    // }
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

  Future<String> genSubtitle(String mediaPath) async {
    // if (!_isInitialized) {
    //   if (initializing) {
    //     await _initializerCompleter.future;
    //   } else {
    //     throw StateError("SubtitleGenerator is not initialized yet.");
    //   }
    // }
    var cparams = whisper.createContextDefaultParams();
    var whisperModel = whisper.Whisper(modelFile.path, cparams);
    return whisperModel.inferIsolate(mediaPath, outputMode: "srt");
  }
}
