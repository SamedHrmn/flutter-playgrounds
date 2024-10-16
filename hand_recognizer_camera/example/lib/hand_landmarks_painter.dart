import 'package:flutter/material.dart';
import 'package:hand_recognizer_camera/result_bundle.dart';

class HandLandmarksPainter extends CustomPainter {
  final ResultBundle resultBundle;
  final double scaleFactorX;
  final double scaleFactorY;
  final Paint linePaint;
  final Paint pointPaint;

  // MediaPipe's HAND_CONNECTIONS
  static const List<List<int>> handConnections = [
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [0, 5],
    [5, 6],
    [6, 7],
    [7, 8],
    [0, 9],
    [9, 10],
    [10, 11],
    [11, 12],
    [0, 13],
    [13, 14],
    [14, 15],
    [15, 16],
    [0, 17],
    [17, 18],
    [18, 19],
    [19, 20],
  ];

  HandLandmarksPainter({
    required this.resultBundle,
    required this.scaleFactorX,
    required this.scaleFactorY,
  })  : linePaint = Paint()
          ..color = Colors.blue
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
        pointPaint = Paint()
          ..color = Colors.yellow
          ..strokeWidth = 4.0
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    for (var hand in resultBundle.results) {
      // Draw landmarks
      for (var landmark in hand.landmarks) {
        canvas.drawCircle(
          Offset(landmark.x * scaleFactorX, landmark.y * scaleFactorY),
          4.0,
          pointPaint,
        );
      }

      // Draw connections
      for (var connection in handConnections) {
        if (connection.length != 2) continue;
        int startIdx = connection[0];
        int endIdx = connection[1];

        // Ensure indices are within bounds
        if (startIdx >= hand.landmarks.length || endIdx >= hand.landmarks.length) {
          continue;
        }

        var startLandmark = hand.landmarks[startIdx];
        var endLandmark = hand.landmarks[endIdx];

        canvas.drawLine(
          Offset(startLandmark.x * scaleFactorX, startLandmark.y * scaleFactorY),
          Offset(endLandmark.x * scaleFactorX, endLandmark.y * scaleFactorY),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    return oldDelegate.resultBundle != resultBundle;
  }
}
