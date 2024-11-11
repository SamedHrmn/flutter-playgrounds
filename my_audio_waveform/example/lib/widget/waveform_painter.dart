import 'package:flutter/material.dart';
import 'package:my_audio_waveform_example/constants/color_constants.dart';

enum WaveformStyle { line, bar }

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color color;
  final WaveformStyle style;

  WaveformPainter(
    this.waveformData, {
    this.color = ColorConstants.primary,
    this.style = WaveformStyle.bar,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = style == WaveformStyle.line ? PaintingStyle.stroke : PaintingStyle.fill;

    if (style == WaveformStyle.line) {
      _drawLineWaveform(canvas, size, paint);
    } else if (style == WaveformStyle.bar) {
      _drawBarWaveform(canvas, size, paint);
    }
  }

  void _drawLineWaveform(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    for (int i = 0; i < waveformData.length; i++) {
      double x = i * (size.width / waveformData.length);
      double y = size.height / 2 + (waveformData[i].clamp(-1, 1) * size.height * 3);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawBarWaveform(Canvas canvas, Size size, Paint paint) {
    final barWidth = size.width / waveformData.length;
    for (int i = 0; i < waveformData.length; i++) {
      double x = i * barWidth;
      double y = (waveformData[i].clamp(-1, 1) * size.height * 3).abs();
      canvas.drawRect(
        Rect.fromLTWH(x, size.height / 2 - y, barWidth, y * 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
