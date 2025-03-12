import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:whisper4dart/whisper4dart.dart' as whisper;
import 'package:synchronized/synchronized.dart';

class SubtitleGenerator {
  bool _isInitialized = false;
  bool initializing = false;
  Completer<void> _initializerCompleter = Completer<void>.sync();
  late String modelnameString;
  late String modelDirectory;
  bool modelExists = false;
  late File modelFile;
  final String modelType;

  SendPort? _isolateSendPort;

  SubtitleGenerator(this.modelType) {
    init();
  }

  void ensureInitialized() async {
    await _initializerCompleter.future;
    return;
  }

  Future<void> init() async {
    if (initializing) {
      await _initializerCompleter.future;
    }
    initializing = true;

    var lock = Lock();
    try {
      await lock.synchronized(() async {
        modelnameString = "ggml-$modelType.bin";
        modelDirectory = path.join(
            (await getApplicationDocumentsDirectory()).path,
            "Playboy",
            "ASRModel");
        modelFile = File(path.join(modelDirectory, modelnameString));
        Directory(modelDirectory).createSync(recursive: true);
        print("Model path: ${modelFile.path}");
        modelExists = modelFile.existsSync();
        _isInitialized = modelExists;
        if (modelExists) {
          _initializerCompleter.complete();
        }
        if (!modelExists) {
          var lock = Lock();
          await lock.synchronized(() async {
            await downloadModel();
          });
        }
      });
    } catch (e) {
      rethrow;
    } finally {
      initializing = false;
    }
  }

  Future<void> downloadModel({int failCount = 0}) async {
    if (failCount > 3) {
      throw Exception("Failed to download model after 3 retries.");
    }
    var lock = Lock();
    await lock.synchronized(() async {
      print("Downloading model...");

      var modelUri = Uri.parse(
          "https://hf-mirror.com/ggerganov/whisper.cpp/resolve/main/$modelnameString?download=true");

      Directory(modelDirectory).createSync(recursive: true);
      var response = await http.get(modelUri);
      if (response.statusCode == 200) {
        var file = File(path.join(modelDirectory, modelnameString));
        await file.writeAsBytes(response.bodyBytes);
        print('File downloaded and saved as $modelnameString');
        print("Model downloaded.");
      } else {
        print("Failed to download model, retrying...");
        await downloadModel(failCount: failCount + 1);
      }
    });
  }

  Future<String> genSubtitle(String mediaPath) async {
    if (!_isInitialized) {
      if (initializing) {
        await _initializerCompleter.future;
      } else {
        throw StateError("SubtitleGenerator is not initialized yet.");
      }
    }
    var cparams = whisper.createContextDefaultParams();
    var whisperModel = whisper.Whisper(modelFile.path, cparams);
    return whisperModel.inferIsolate(mediaPath, outputMode: "srt");
  }
}
