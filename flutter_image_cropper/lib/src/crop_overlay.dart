import 'package:flutter/material.dart';

class CropOverlayPainter extends CustomPainter {
  final Rect rect; // pixel space
  final double handleSize;
  final double borderWidth;

  CropOverlayPainter({
    required this.rect,
    this.handleSize = 20,
    this.borderWidth = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1;

    // 🔲 Crop border
    canvas.drawRect(rect, borderPaint);

    // 🔳 Grid (rule of thirds)
    final thirdW = rect.width / 3;
    final thirdH = rect.height / 3;

    for (int i = 1; i <= 2; i++) {
      // Vertical
      canvas.drawLine(
        Offset(rect.left + thirdW * i, rect.top),
        Offset(rect.left + thirdW * i, rect.bottom),
        gridPaint,
      );

      // Horizontal
      canvas.drawLine(
        Offset(rect.left, rect.top + thirdH * i),
        Offset(rect.right, rect.top + thirdH * i),
        gridPaint,
      );
    }

    // 🟦 Corner handles
    _drawCorner(canvas, rect.topLeft, Corner.topLeft);
    _drawCorner(canvas, rect.topRight, Corner.topRight);
    _drawCorner(canvas, rect.bottomLeft, Corner.bottomLeft);
    _drawCorner(canvas, rect.bottomRight, Corner.bottomRight);
  }

  void _drawCorner(Canvas canvas, Offset corner, Corner type) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;

    final s = handleSize;

    switch (type) {
      case Corner.topLeft:
        canvas.drawLine(corner, corner + Offset(s, 0), paint);
        canvas.drawLine(corner, corner + Offset(0, s), paint);
        break;

      case Corner.topRight:
        canvas.drawLine(corner, corner + Offset(-s, 0), paint);
        canvas.drawLine(corner, corner + Offset(0, s), paint);
        break;

      case Corner.bottomLeft:
        canvas.drawLine(corner, corner + Offset(s, 0), paint);
        canvas.drawLine(corner, corner + Offset(0, -s), paint);
        break;

      case Corner.bottomRight:
        canvas.drawLine(corner, corner + Offset(-s, 0), paint);
        canvas.drawLine(corner, corner + Offset(0, -s), paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CropOverlayPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}

enum Corner { topLeft, topRight, bottomLeft, bottomRight }
