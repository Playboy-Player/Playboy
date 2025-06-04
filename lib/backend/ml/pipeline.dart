import 'dart:ui' as ui;

import 'package:playboy/backend/ml/llm_services.dart';
import 'dart:convert';

import 'package:meta/meta.dart';

bool isSRTValid(String srtContent, {bool requireSequentialIndex = true}) {
  if (srtContent.trim().isEmpty) {
    print("Validation Error: Input string is empty or only whitespace.");
    return false;
  }

  // 1. Normalize line endings and split into blocks
  // SRT blocks are separated by one blank line (which means two newlines).
  final blocks = srtContent.replaceAll('\r\n', '\n').trim().split('\n\n');

  // Regular expression for the timestamp line
  final timestampRegex = RegExp(
    r'^\d{2}:\d{2}:\d{2},\d{3}\s*-->\s*\d{2}:\d{2}:\d{2},\d{3}$',
  );

  int expectedIndex = 1;

  // 2. Validate each block
  for (int i = 0; i < blocks.length; i++) {
    final block = blocks[i].trim(); // Trim whitespace for the individual block
    if (block.isEmpty) {
      // This can happen if there are multiple blank lines between entries
      print(
          "Validation Error: Encountered an effectively empty block (likely extra blank lines). Problem near expected index $expectedIndex.");
      return false;
    }

    final lines = block.split('\n');

    // Check minimum number of lines (Index, Timestamp, Text)
    if (lines.length < 3) {
      print(
          "Validation Error: Block ${i + 1} (around expected index $expectedIndex) has too few lines (${lines.length}). Need index, timestamp, and text.");
      print("Block content:\n---\n$block\n---");
      return false;
    }

    // --- Validate Line 1: Index ---
    final indexStr = lines[0].trim();
    final currentIndex = int.tryParse(indexStr);

    if (currentIndex == null) {
      print(
          "Validation Error: Block ${i + 1} has an invalid index line: '$indexStr'. Not a number.");
      return false;
    }

    if (currentIndex <= 0) {
      print(
          "Validation Error: Block ${i + 1} has a non-positive index: $currentIndex.");
      return false;
    }

    if (requireSequentialIndex) {
      if (currentIndex != expectedIndex) {
        print(
            "Validation Error: Block index mismatch. Expected $expectedIndex but got $currentIndex.");
        return false;
      }
      expectedIndex++;
    } else {
      // If not requiring sequence, just ensure it's positive.
      // We could update expectedIndex for the *next* block if we wanted optional sequence checks later
      expectedIndex = currentIndex +
          1; // Predict next index even if not strictly enforced now
    }

    // --- Validate Line 2: Timestamp ---
    final timestampLine = lines[1].trim();
    if (!timestampRegex.hasMatch(timestampLine)) {
      print(
          "Validation Error: Block $currentIndex has an invalid timestamp format: '$timestampLine'.");
      print("Expected format: HH:MM:SS,mmm --> HH:MM:SS,mmm");
      return false;
    }
    // Optional: Add logic here to parse times and check if start_time <= end_time

    // --- Validate Line 3+: Text ---
    // We already checked lines.length >= 3, so we know there's at least one text line.
    // No specific format check needed for the text itself usually.
  } // End of loop through blocks

  // If we passed all blocks without returning false, it's valid.
  return true;
}

bool isJsonValid(String jsonString) {
  try {
    json.decode(jsonString);
    return true;
  } on FormatException catch (_) {
    return false;
  }
}

abstract class Step<Input, Output> {
  Future<Output> execute(Input input);
}

class Pipeline<Input, Output> implements Step<Input, Output> {
  final List<Step> steps;

  Pipeline({required this.steps});

  @override
  Future<Output> execute(Input input) async {
    dynamic result = input;
    for (var step in steps) {
      result = await step.execute(result);
    }
    return result as Output;
  }
}

class OCRStep implements Step<Uri, String> {
  final ApiConfig apiConfig;
  final String modelName;
  final OpenAICompatibleLLM llm;
  String translationPrompt = "";

  final String? tarLang;

  OCRStep({required this.apiConfig, required this.modelName, this.tarLang})
      : llm = OpenAICompatibleLLM(config: apiConfig);

  @override
  Future<String> execute(Uri input) async {
    if (tarLang != null) {
      translationPrompt = "-Translate all the text to $tarLang:\n";
    }

    final multimodalInput = MultimodalInput(
      text:
          """You are an AI assistant proficient in image recognition and data extraction. Your task is to analyze the provided image, identify all text and table structures within it, and output the recognition results in JSON format.
Also, output structured data in pure JSON format without any additional text, explanations, or Markdown formatting such as ```json. Ensure that the output is valid JSON and can be parsed directly using standard JSON parsers.
Please follow these rules:
- For regular text elements, output their "type", "bbox", and "text",if this text element is included in a table,do not output it as text again.
- For tables:
  - Always include "type", "bbox", and "markdown_table".
- Keep the structure clean and consistent.
$translationPrompt

Use this JSON schema as a reference:

{
  "image_description": "string",
  "recognized_elements": [
    {
      "type": "text",
      "bbox": [x_min, y_min, x_max, y_max],
      "text": "string"
    },
    {
      "type": "table",
      "bbox": [x_min, y_min, x_max, y_max],
      "markdown_table": "string",
    }
  ]
}""",
      imageUris: [input],
    );
    String result =
        await llm.generateContent(multimodalInput, model: modelName);
    try {
      json.decode(result);
      return result;
    } on FormatException catch (_) {
      throw Exception('Invalid JSON');
    }
  }
}

class OCRPipeline extends Pipeline<Uri, String> {
  OCRPipeline(
      {required ApiConfig apiConfig,
      required String modelName,
      String? tarLang})
      : super(steps: [
          OCRStep(apiConfig: apiConfig, modelName: modelName, tarLang: tarLang)
        ]);
}

class SRTtranslationStep implements Step<(String, String), String> {
  final ApiConfig apiConfig;
  final String modelName;
  final OpenAICompatibleLLM llm;

  SRTtranslationStep({required this.apiConfig, required this.modelName})
      : llm = OpenAICompatibleLLM(config: apiConfig);

  @override
  Future<String> execute((String, String) input) async {
    final (String text, String TarLang) = input;
    final multimodalInput = MultimodalInput(
      text: """
# Task
Your task is to translate the provided SRT subtitle text content from [Source Language] to [Target Language].
The **most critical requirement** is that you **MUST strictly preserve** the original SRT file format. This includes:
    *   Index numbers
    *   Timestamp lines (e.g., `00:00:00,000 --> 00:00:00,000`)
    *   Blank lines separating entries

**DO NOT** translate the index numbers or the timestamps. Only translate the actual subtitle text.

# Input
You will receive a string containing SRT subtitle content. The format for each entry is:
<Index Number>
<Start Time --> End Time>
<Subtitle Text (can be multi-line)>
[Blank Line]

# Output Requirements
1.  **Translate Content**: Only translate the `<Subtitle Text>` portion.
2.  **Preserve Format**: Strictly keep the original index numbers, timestamps (`<Start Time --> End Time>`), and the blank lines between entries. The number of lines for the translated text should ideally be similar to the original if linguistically appropriate, but accuracy of translation takes precedence.
3.  **No Translation of Structure**: Do not translate index numbers. Do not translate timestamps.
4.  **Output Format**: Output a complete string that can be directly saved as an `.srt` file.

# Translation Languages
*   Target Language: $TarLang

# SRT Subtitle Content

$text
""",
    );
    String result =
        await llm.generateContent(multimodalInput, model: modelName);
    if (isSRTValid(result)) {
      return result;
    } else {
      throw Exception('Invalid SRT');
    }
  }
}

class SRTtranslationPipeline extends Pipeline<String, String> {
  SRTtranslationPipeline(
      {required ApiConfig apiConfig, required String modelName})
      : super(steps: [
          SRTtranslationStep(apiConfig: apiConfig, modelName: modelName)
        ]);
}
