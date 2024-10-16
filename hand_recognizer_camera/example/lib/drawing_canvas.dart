import 'package:flutter/material.dart';
import 'package:hand_recognizer_camera/result_bundle.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key, required this.resultBundle});

  final ResultBundle resultBundle;

  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final List<Offset> _points = [];
  final List<Offset> _buffer = [];

  @override
  void didUpdateWidget(covariant DrawingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resultBundle != widget.resultBundle) {
      _processResultBundle(widget.resultBundle);
    }
  }

  /// Processes the incoming ResultBundle to extract and add points.
  void _processResultBundle(ResultBundle resultBundle) {
    if (resultBundle.results.isEmpty) return;

    HandLandmarkerResult hand = resultBundle.results.first;

    if (hand.landmarks.length > 8) {
      // Extract index finger tip (assuming landmark 8 is the tip)
      Landmark indexFingerTip = hand.landmarks[8];
      Offset screenPosition = _normalizedToScreen(indexFingerTip);
      bool isFingerUp = _isFingerExtended(hand);

      _addPoint(screenPosition, isFingerUp);
    }
  }

  /// Determines if the index finger is extended based on landmarks.
  bool _isFingerExtended(HandLandmarkerResult hand) {
    if (hand.landmarks.length > 8 && hand.landmarks.length > 6) {
      double tipY = hand.landmarks[8].y;
      double pipY = hand.landmarks[6].y;
      return (pipY - tipY) > 0.05; // Adjust threshold as needed
    }
    return false;
  }

  /// Converts normalized landmark coordinates to screen coordinates.
  Offset _normalizedToScreen(Landmark landmark) {
    double screenX = landmark.x * MediaQuery.of(context).size.width;
    double screenY = landmark.y * MediaQuery.of(context).size.height;
    return Offset(screenX, screenY);
  }

  /// Adds a new point to the drawing, applying smoothing and movement threshold.
  void _addPoint(Offset point, bool isFingerUp) {
    if (isFingerUp) {
      // If the finger is up, just add a sentinel value
      if (_points.isNotEmpty && _points.last == const Offset(-1, -1)) {
        return; // Avoid adding multiple sentinel values
      }
      _points.add(point);
    } else {
      // If the finger is down, update the points
      if (_points.isNotEmpty) {
        Offset lastPoint = _points.last;
        // Add some intermediate points for smoother drawing
        double dx = (point.dx - lastPoint.dx) / 5; // 5 segments for smoothing
        double dy = (point.dy - lastPoint.dy) / 5;

        for (int i = 0; i < 5; i++) {
          _points.add(Offset(lastPoint.dx + dx * i, lastPoint.dy + dy * i));
        }
      } else {
        // If no previous points, just add the new point
        _points.add(point);
      }
    }

    // Limit the number of points to prevent memory issues
    if (_points.length > 1000) {
      _points.removeAt(0);
    }
  }

  /// Clears the drawing canvas.
  void clearDrawing() {
    setState(() {
      _points.clear();
      _buffer.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandDrawingPainter(_points),
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class HandDrawingPainter extends CustomPainter {
  final List<Offset> points;

  HandDrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    final Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
