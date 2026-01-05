import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

enum CropHandle { none, move, topLeft, topRight, bottomLeft, bottomRight }

class CropController extends ChangeNotifier {
  Rect cropRect;
  double? aspectRatio;
  static const double _snapThreshold = 0.015;

  CropController({Rect? initialRect, this.aspectRatio})
    : cropRect = initialRect ?? const Rect.fromLTWH(0.2, 0.2, 0.6, 0.6);

  void setAspectRatio(double? ratio) {
    aspectRatio = ratio;

    if (ratio != null) {
      cropRect = _applyAspectRatioKeepingCenter(cropRect, ratio);
      cropRect = _clamp(cropRect);
    }

    notifyListeners();
  }

  void updateRect(Rect rect) {
    cropRect = clampAndSnap(rect);
    notifyListeners();
  }

  Future<Color> averageColorFromImage(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    final data = byteData!.buffer.asUint8List();

    int r = 0, g = 0, b = 0;
    final pixelCount = image.width * image.height;

    for (int i = 0; i < data.length; i += 4) {
      r += data[i];
      g += data[i + 1];
      b += data[i + 2];
    }

    return Color.fromARGB(
      255,
      r ~/ pixelCount,
      g ~/ pixelCount,
      b ~/ pixelCount,
    );
  }

  Rect _applyAspectRatioKeepingCenter(Rect rect, double ratio) {
    final center = rect.center;
    final width = rect.width;
    final height = width / ratio;

    return Rect.fromCenter(center: center, width: width, height: height);
  }

  Rect _clamp(Rect rect) {
    return Rect.fromLTRB(
      rect.left.clamp(0.0, 1.0),
      rect.top.clamp(0.0, 1.0),
      rect.right.clamp(0.0, 1.0),
      rect.bottom.clamp(0.0, 1.0),
    );
  }

  CropHandle hitTestHandle(
    Offset position,
    Rect rect,
    double width,
    double height,
  ) {
    const handleSize = 24.0;

    Rect handleRect(Offset center) =>
        Rect.fromCenter(center: center, width: handleSize, height: handleSize);

    final r = Rect.fromLTWH(
      rect.left * width,
      rect.top * height,
      rect.width * width,
      rect.height * height,
    );

    if (handleRect(r.topLeft).contains(position)) return CropHandle.topLeft;
    if (handleRect(r.topRight).contains(position)) return CropHandle.topRight;
    if (handleRect(r.bottomLeft).contains(position)) {
      return CropHandle.bottomLeft;
    }
    if (handleRect(r.bottomRight).contains(position)) {
      return CropHandle.bottomRight;
    }

    if (r.contains(position)) return CropHandle.move;

    return CropHandle.none;
  }

  Rect clampAndSnap(Rect rect) {
    double left = rect.left;
    double top = rect.top;
    double right = rect.right;
    double bottom = rect.bottom;

    // SNAP
    if (left.abs() < _snapThreshold) left = 0;
    if (top.abs() < _snapThreshold) top = 0;
    if ((1 - right).abs() < _snapThreshold) right = 1;
    if ((1 - bottom).abs() < _snapThreshold) bottom = 1;

    // CLAMP
    left = left.clamp(0.0, 1.0);
    top = top.clamp(0.0, 1.0);
    right = right.clamp(0.0, 1.0);
    bottom = bottom.clamp(0.0, 1.0);

    // Rect'in ters dönmesini engelle
    const minSize = 0.05;
    if (right - left < minSize) right = left + minSize;
    if (bottom - top < minSize) bottom = top + minSize;

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Offset clampDeltaForRect(Rect rect, Offset delta, CropHandle handle) {
    double dx = delta.dx;
    double dy = delta.dy;

    switch (handle) {
      case CropHandle.move:
        if (rect.left + dx < 0) dx = -rect.left;
        if (rect.right + dx > 1) dx = 1 - rect.right;
        if (rect.top + dy < 0) dy = -rect.top;
        if (rect.bottom + dy > 1) dy = 1 - rect.bottom;
        break;

      case CropHandle.topLeft:
        if (rect.left + dx < 0) dx = -rect.left;
        if (rect.top + dy < 0) dy = -rect.top;
        break;

      case CropHandle.topRight:
        if (rect.right + dx > 1) dx = 1 - rect.right;
        if (rect.top + dy < 0) dy = -rect.top;
        break;

      case CropHandle.bottomLeft:
        if (rect.left + dx < 0) dx = -rect.left;
        if (rect.bottom + dy > 1) dy = 1 - rect.bottom;
        break;

      case CropHandle.bottomRight:
        if (rect.right + dx > 1) dx = 1 - rect.right;
        if (rect.bottom + dy > 1) dy = 1 - rect.bottom;
        break;

      case CropHandle.none:
        return Offset.zero;
    }

    return Offset(dx, dy);
  }
}
