class WhisperModel {
  WhisperModel(this.name, this.link);
  String name;
  String link;
}

List<String> _modelNames = [
  'ggml-base-q5_1.bin',
  'ggml-base-q8_0.bin',
  'ggml-base.bin',
  'ggml-tiny-q5_1.bin',
  'ggml-tiny-q8_0.bin',
  'ggml-tiny.bin',
  'ggml-small-q5_1.bin',
  'ggml-small-q8_0.bin',
  'ggml-small.bin',
  'ggml-medium-q5_0.bin',
  'ggml-medium-q8_0.bin',
  'ggml-medium.bin',
  'ggml-large-v1.bin',
  'ggml-large-v2-q5_0.bin',
  'ggml-large-v2-q8_0.bin',
  'ggml-large-v2.bin',
  'ggml-large-v3-turbo-q5_0.bin',
  'ggml-large-v3-q5_0.bin',
  'ggml-large-v3-turbo-q8_0.bin',
  'ggml-large-v3-turbo.bin',
  'ggml-large-v3.bin',
];

List<WhisperModel> models = List.generate(
  _modelNames.length,
  (index) => WhisperModel(
    _modelNames[index],
    'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/${_modelNames[index]}?download=true',
  ),
);

List<WhisperModel> modelsMirror = List.generate(
  _modelNames.length,
  (index) => WhisperModel(
    _modelNames[index],
    'https://hf-mirror.com/ggerganov/whisper.cpp/resolve/main/${_modelNames[index]}?download=true',
  ),
);
