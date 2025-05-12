import 'dart:convert';
import 'dart:io'; // 用于处理文件和URI
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p; // 用于处理路径
import 'dart:developer' as dev;

// --- 1. 配置管理 ---
class ApiConfig {
  final String apiKey;
  final String baseUrl; // 例如: "https://api.openai.com/v1" 或其他兼容API的地址

  ApiConfig({required this.apiKey, required this.baseUrl});
}

// --- 2. 请求封装 ---
class MultimodalInput {
  final String? text;
  final List<Uri>? imageUris; // 支持多个图像URI

  MultimodalInput({this.text, this.imageUris});

  // 辅助方法：将本地文件URI转换为Base64编码的字符串
  // 注意：这只是一个示例，具体实现取决于API的要求
  Future<List<Map<String, dynamic>>?> getEncodedImages() async {
    if (imageUris == null || imageUris!.isEmpty) {
      return null;
    }

    List<Map<String, dynamic>> encodedImages = [];
    for (var uri in imageUris!) {
      if (uri.scheme == 'file') {
        try {
          final file = File.fromUri(uri);
          final bytes = await file.readAsBytes();
          final base64Image = base64Encode(bytes);
          final mimeType = _getMimeType(file.path) ?? 'image/jpeg'; // 默认为jpeg
          encodedImages.add({
            "type": "image_url",
            "image_url": {"url": "data:$mimeType;base64,$base64Image"}
          });
        } catch (e) {
          dev.log("Error encoding image ${uri.path}: $e");
          // 可以选择跳过此图像或抛出异常
        }
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        // 如果API支持直接传入URL
        encodedImages.add({
          "type": "image_url",
          "image_url": {"url": uri.toString()}
        });
      } else if (uri.scheme == 'data') {
        encodedImages.add({
          "type": "image_url",
          "image_url": {"url": uri.toString()}
        });
      } else {
        dev.log("Unsupported URI scheme: ${uri.scheme}");
      }
    }
    return encodedImages.isNotEmpty ? encodedImages : null;
  }

  String? _getMimeType(String filePath) {
    final extension = p.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      // 可以根据需要添加更多类型
      default:
        return null; // 或者返回一个默认的MIME类型
    }
  }
}

// --- 3. 抽象模型接口 ---
abstract class LLMService {
  Future<String> generateContent(MultimodalInput input, {String? model});
}

// --- 4. 具体模型实现 (OpenAI 兼容 API) ---
class OpenAICompatibleLLM implements LLMService {
  final ApiConfig config;
  final http.Client _httpClient;

  OpenAICompatibleLLM({required this.config, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  Future<String> generateContent(
    MultimodalInput input, {
    String? model = "gpt-4o", // 默认模型
    String? systemPrompt, // 新增: 系统提示词参数
  }) async {
    final url = Uri.parse('${config.baseUrl}/chat/completions');

    List<Map<String, dynamic>> messages = [];

    // 1. 添加系统提示词 (如果提供)
    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messages.add({
        "role": "system",
        "content": systemPrompt,
      });
    } else {
      messages.add({
        "role": "system",
        "content": "You are a helpful assistant.",
      });
    }

    // 2. 准备用户消息内容
    List<Map<String, dynamic>> userContentParts = [];
    if (input.text != null && input.text!.isNotEmpty) {
      userContentParts.add({"type": "text", "text": input.text!});
    }

    final encodedImages = await input.getEncodedImages();
    if (encodedImages != null) {
      userContentParts
          .addAll(encodedImages.map((img) => Map<String, dynamic>.from(img)));
    }

    // 用户消息必须有内容 (文本或图像)
    if (userContentParts.isEmpty) {
      // 如果有系统提示但没有用户输入，这可能仍然是一个有效的请求 (例如，让系统角色开始对话)
      // 但通常我们期望用户提供一些输入。根据具体API行为调整。
      // 对于OpenAI，通常期望至少有一个非系统角色的消息。
      // 如果只有system prompt，而没有user prompt，根据API设计可能会报错或行为不确定。
      // 这里我们假设如果用户消息为空，则是一个无效输入，除非只有系统提示。
      // 但通常调用者应确保有用户输入。
      if (messages.where((msg) => msg['role'] == 'user').isEmpty &&
          userContentParts.isEmpty) {
        throw ArgumentError(
            "User input (text or images) must be provided if no prior user messages exist.");
      }
    }

    // 添加用户消息
    // 如果 userContentParts 不为空，才添加 user message
    if (userContentParts.isNotEmpty) {
      messages.add({
        "role": "user",
        "content": userContentParts,
      });
    }

    // 如果 messages 列表为空 (例如，没有 system prompt 也没有 user input)，则抛出错误
    // 实际上，上面的逻辑已经会因为 userContentParts.isEmpty 而抛错（如果text和image都无）
    // OpenAI API 至少需要一个用户消息或系统消息（通常两者都有）
    if (messages.isEmpty) {
      throw ArgumentError(
          "Cannot send an empty message list to the API. Provide a system prompt or user input.");
    }

    final body = jsonEncode({
      'model': model,
      'messages': messages,
      // 'max_tokens': 300, // 示例
      // 'temperature': 0.7, // 示例
    });

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${config.apiKey}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseBody['choices'] != null &&
            responseBody['choices'].isNotEmpty &&
            responseBody['choices'][0]['message'] != null &&
            responseBody['choices'][0]['message']['content'] != null) {
          return responseBody['choices'][0]['message']['content'] as String;
        } else {
          dev.log("Unexpected response format: ${response.body}");
          throw Exception('Failed to parse LLM response: Unexpected format');
        }
      } else {
        dev.log("Error from API: ${response.statusCode} ${response.body}");
        // 可以尝试解析错误响应体以获取更详细的错误信息
        String errorMessage = response.body;
        try {
          final errorJson = jsonDecode(utf8.decode(response.bodyBytes));
          if (errorJson['error'] != null &&
              errorJson['error']['message'] != null) {
            errorMessage = errorJson['error']['message'];
          }
        } catch (_) {
          // 忽略解析错误，使用原始 body
        }
        throw Exception(
            'Failed to get response from LLM: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      dev.log("Error sending request to LLM: $e");
      throw Exception('Failed to send request to LLM: $e');
    }
  }
}
