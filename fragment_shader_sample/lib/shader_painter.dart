import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  final ui.Image image;
  final ui.FragmentShader shader;

  ShaderPainter({
    super.repaint,
    required this.image,
    required this.shader,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.shader = shader;
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) => true;
}
