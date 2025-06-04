import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:async';
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show listEquals; // For listEquals in painter
import 'package:file_picker/file_picker.dart'; // Your existing import
import 'package:playboy/backend/ml/pipeline.dart';
import 'package:playboy/backend/app.dart';

// Put this near your other class definitions or in a separate models file
class RecognizedElement {
  final String type;
  final List<double> bbox; // [xmin, ymin, xmax, ymax]
  final String? text;
  final String? markdownTable; // We'll mostly use text for drawing

  RecognizedElement({
    required this.type,
    required this.bbox,
    this.text,
    this.markdownTable,
  });

  factory RecognizedElement.fromJson(Map<String, dynamic> json) {
    return RecognizedElement(
      type: json['type'] as String,
      bbox: (json['bbox'] as List).map((e) => (e as num).toDouble()).toList(),
      text: json['text'] as String?,
      markdownTable: json['markdown_table'] as String?,
    );
  }

  Rect get rect {
    // Assuming bbox is [xmin, ymin, xmax, ymax]
    if (bbox.length == 4) {
      return Rect.fromLTRB(bbox[0], bbox[1], bbox[2], bbox[3]);
    }
    // Fallback or error, though your OCR seems to guarantee 4 points
    return Rect.zero;
  }
}

class OCRResultPainter extends CustomPainter {
  final ui.Image screenshotImage;
  final List<RecognizedElement> ocrResults;
  final Size originalImageSize; // OCR分析的图像的原始尺寸 (例如 1920x1080)

  OCRResultPainter({
    required this.screenshotImage,
    required this.ocrResults,
    required this.originalImageSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // `size` 是 CustomPaint widget 在屏幕上的实际尺寸
    if (originalImageSize.width == 0 || originalImageSize.height == 0) {
      print(
          "OCRResultPainter: Warning - originalImageSize is zero. Drawing image directly.");
      // 如果原始尺寸无效，则直接绘制图像而不进行缩放或OCR框
      paintImage(
          canvas: canvas,
          rect: Rect.fromLTWH(0, 0, size.width, size.height),
          image: screenshotImage,
          fit: BoxFit.contain); // 或者 BoxFit.cover
      return;
    }

    // --- 1. 计算图像在画布中的实际显示区域和缩放比例 ---
    // 我们需要以 BoxFit.contain 的方式绘制图像，并计算出图像在画布中的实际边界和缩放
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, originalImageSize, size);
    final Rect sourceRect = Alignment.center
        .inscribe(fittedSizes.source, Offset.zero & originalImageSize);
    final Rect destRect =
        Alignment.center.inscribe(fittedSizes.destination, Offset.zero & size);

    // `destRect` 就是图像在画布上实际绘制的区域
    // `sourceRect` 通常是 (0,0) 到 (originalImageSize.width, originalImageSize.height)

    // 绘制背景图 (视频截图)
    canvas.drawImageRect(screenshotImage, sourceRect, destRect, Paint());

    // 计算从原始bbox坐标到画布上destRect内部坐标的缩放比例
    // Bbox 坐标是相对于 originalImageSize 的
    final double scaleX = destRect.width / originalImageSize.width;
    final double scaleY = destRect.height / originalImageSize.height;

    final Paint boxPaint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint textBackgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.6);

    // --- 2. 遍历OCR结果并绘制 ---
    for (var element in ocrResults) {
      if (element.bbox.length == 4 && element.rect != Rect.zero) {
        final Rect originalBbox =
            element.rect; // 这是相对于 originalImageSize 的 bbox

        // 将原始 bbox 坐标映射到画布上的 destRect 内部
        final Rect scaledBboxOnCanvas = Rect.fromLTRB(
          destRect.left + (originalBbox.left * scaleX),
          destRect.top + (originalBbox.top * scaleY),
          destRect.left + (originalBbox.right * scaleX),
          destRect.top + (originalBbox.bottom * scaleY),
        );

        // 绘制 bbox
        canvas.drawRect(scaledBboxOnCanvas, boxPaint);

        // 绘制文本
        if (element.text != null && element.text!.isNotEmpty) {
          final double fontSize =
              (12.0 * scaleX).clamp(8.0, 24.0); // 根据宽度缩放字体，并限制大小
          final TextSpan span = TextSpan(
            style: TextStyle(
              color: Colors.yellow,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                    blurRadius: 1.0, color: Colors.black, offset: Offset(1, 1))
              ],
            ),
            text: element.text,
          );
          final TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: ui.TextDirection.ltr,
          );
          // 限制文本画笔的最大宽度
          tp.layout(
              minWidth: 0,
              maxWidth: scaledBboxOnCanvas.width * 1.5); // 可以比bbox略宽一点

          // 文本定位逻辑 (尝试在框上方，如果空间不足则在框内或下方)
          double textX = scaledBboxOnCanvas.left;
          double textY = scaledBboxOnCanvas.top -
              tp.height -
              (2 * scaleY); // 默认在上方 (2px 间距)

          // 调整Y，防止出画布顶端
          if (textY < destRect.top) {
            textY = scaledBboxOnCanvas.bottom + (2 * scaleY); // 尝试在下方
          }
          // 调整Y，防止出画布底端 (如果放在下方了)
          if (textY + tp.height > destRect.bottom) {
            // 如果下方也出界，或者即使在上方也会被遮挡，则尝试放在框内顶部
            textY = scaledBboxOnCanvas.top + (2 * scaleY);
            // 如果框内顶部也放不下（比如bbox本身很扁），则可能重叠或需要更复杂逻辑
            if (textY + tp.height > scaledBboxOnCanvas.bottom - (2 * scaleY) &&
                scaledBboxOnCanvas.height > tp.height + (4 * scaleY)) {
              // 简单处理：放在框内，并确保不溢出框底
              textY = (scaledBboxOnCanvas.top +
                      (scaledBboxOnCanvas.height - tp.height) / 2)
                  .clamp(scaledBboxOnCanvas.top,
                      scaledBboxOnCanvas.bottom - tp.height);
            } else if (scaledBboxOnCanvas.height <= tp.height + (4 * scaleY)) {
              // 实在太扁，就放在框的上方，可能会超出destRect一点点
              textY = scaledBboxOnCanvas.top - tp.height - (2 * scaleY);
              if (textY < 0) textY = 0; // 不要画到画布外
            }
          }

          // 调整X，防止出画布左右边界
          if (textX < destRect.left) textX = destRect.left;
          if (textX + tp.width > destRect.right) {
            textX = destRect.right - tp.width;
          }

          final textBackgroundRect = Rect.fromLTWH(
            textX - (1 * scaleX), // 左右留一点padding
            textY - (1 * scaleY), // 上下留一点padding
            tp.width + (2 * scaleX),
            tp.height + (2 * scaleY),
          );

          // 确保背景和文本都在画布的有效绘制区域 (destRect) 内
          canvas.drawRect(
              textBackgroundRect.intersect(destRect), textBackgroundPaint);
          tp.paint(canvas, Offset(textX, textY));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant OCRResultPainter oldDelegate) {
    return oldDelegate.screenshotImage != screenshotImage ||
        !listEquals(oldDelegate.ocrResults, ocrResults) ||
        oldDelegate.originalImageSize != originalImageSize;
  }
}
