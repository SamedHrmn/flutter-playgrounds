import 'dart:ui';

Rect applyAspectRatio(Rect rect, double aspectRatio) {
  final width = rect.width;
  final height = width / aspectRatio;
  return Rect.fromCenter(
    center: rect.center,
    width: width,
    height: height,
  );
}

Rect clampRect(Rect rect) {
  return Rect.fromLTRB(
    rect.left.clamp(0.0, 1.0),
    rect.top.clamp(0.0, 1.0),
    rect.right.clamp(0.0, 1.0),
    rect.bottom.clamp(0.0, 1.0),
  );
}
