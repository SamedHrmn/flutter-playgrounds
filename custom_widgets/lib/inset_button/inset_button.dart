import 'dart:math' as math;
import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/painting.dart' as painting;

class BoxDecoration extends painting.BoxDecoration {
  const BoxDecoration({
    super.color,
    DecorationImage? image,
    super.border,
    super.borderRadius,
    List<BoxShadow>? super.boxShadow,
    super.gradient,
    super.backgroundBlendMode,
    super.shape,
  });

  @override
  BoxDecoration copyWith({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<painting.BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
  }) {
    assert(boxShadow is List<BoxShadow>?);

    return BoxDecoration(
      color: color ?? this.color,
      image: image ?? this.image,
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: (boxShadow ?? this.boxShadow) as List<BoxShadow>?,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
    );
  }

  @override
  BoxDecoration scale(double factor) {
    return BoxDecoration(
      color: Color.lerp(null, color, factor),
      image: image,
      border: BoxBorder.lerp(null, border, factor),
      borderRadius: BorderRadiusGeometry.lerp(null, borderRadius, factor),
      boxShadow: BoxShadow.lerpList(null, boxShadow as List<BoxShadow>?, factor),
      gradient: gradient?.scale(factor),
      shape: shape,
    );
  }

  @override
  BoxDecoration? lerpFrom(Decoration? a, double t) {
    if (a == null) return scale(t);
    if (a is BoxDecoration) return BoxDecoration.lerp(a, this, t);
    return super.lerpFrom(a, t) as BoxDecoration?;
  }

  @override
  BoxDecoration? lerpTo(Decoration? b, double t) {
    if (b == null) return scale(1.0 - t);
    if (b is BoxDecoration) return BoxDecoration.lerp(this, b, t);
    return super.lerpTo(b, t) as BoxDecoration?;
  }

  static BoxDecoration? lerp(BoxDecoration? a, BoxDecoration? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return BoxDecoration(
      color: Color.lerp(a.color, b.color, t),
      image: t < 0.5 ? a.image : b.image,
      border: BoxBorder.lerp(a.border, b.border, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      boxShadow: BoxShadow.lerpList(
        a.boxShadow as List<BoxShadow>?,
        b.boxShadow as List<BoxShadow>?,
        t,
      ),
      gradient: Gradient.lerp(a.gradient, b.gradient, t),
      shape: t < 0.5 ? a.shape : b.shape,
    );
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(onChanged != null || image == null);
    return _InsetBoxDecorationPainter(this, onChanged);
  }
}

class _InsetBoxDecorationPainter extends BoxPainter {
  _InsetBoxDecorationPainter(
    this._decoration,
    VoidCallback? onChanged,
  ) : super(onChanged);

  final BoxDecoration _decoration;

  Paint? _cachedBackgroundPaint;
  Rect? _rectForCachedBackgroundPaint;
  Paint _getBackgroundPaint(Rect rect, TextDirection? textDirection) {
    assert(_decoration.gradient != null || _rectForCachedBackgroundPaint == null);

    if (_cachedBackgroundPaint == null || (_decoration.gradient != null && _rectForCachedBackgroundPaint != rect)) {
      final paint = Paint();
      if (_decoration.backgroundBlendMode != null) {
        paint.blendMode = _decoration.backgroundBlendMode!;
      }
      if (_decoration.color != null) paint.color = _decoration.color!;
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient!.createShader(
          rect,
          textDirection: textDirection,
        );
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint!;
  }

  void _paintBox(Canvas canvas, Rect rect, Paint paint, TextDirection? textDirection) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final center = rect.center;
        final radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, paint);

      case BoxShape.rectangle:
        if (_decoration.borderRadius == null) {
          canvas.drawRect(rect, paint);
        } else {
          canvas.drawRRect(
            _decoration.borderRadius!.resolve(textDirection).toRRect(rect),
            paint,
          );
        }
    }
  }

  void _paintOuterShadows(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
  ) {
    if (_decoration.boxShadow == null) {
      return;
    }
    for (final boxShadow in _decoration.boxShadow!) {
      if (boxShadow is BoxShadow) {
        if (boxShadow.inset) {
          continue;
        }
      }
      final paint = boxShadow.toPaint();
      final bounds = rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }

  void _paintBackgroundColor(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
  ) {
    if (_decoration.color != null || _decoration.gradient != null) {
      _paintBox(
        canvas,
        rect,
        _getBackgroundPaint(rect, textDirection),
        textDirection,
      );
    }
  }

  DecorationImagePainter? _imagePainter;
  void _paintBackgroundImage(Canvas canvas, Rect rect, ImageConfiguration configuration) {
    if (_decoration.image == null) return;
    _imagePainter ??= _decoration.image!.createPainter(onChanged!);
    Path? clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final center = rect.center;
        final radius = rect.shortestSide / 2.0;
        final square = Rect.fromCircle(center: center, radius: radius);
        clipPath = Path()..addOval(square);

      case BoxShape.rectangle:
        if (_decoration.borderRadius != null) {
          clipPath = Path()..addRRect(_decoration.borderRadius!.resolve(configuration.textDirection).toRRect(rect));
        }
    }
    _imagePainter!.paint(canvas, rect, clipPath, configuration);
  }

  void _paintInnerShadows(
    Canvas canvas,
    Rect rect,
    TextDirection? textDirection,
  ) {
    if (_decoration.boxShadow == null) {
      return;
    }
    for (final boxShadow in _decoration.boxShadow!) {
      if (boxShadow is! BoxShadow || !boxShadow.inset) {
        continue;
      }

      final color = boxShadow.color.withOpacity(1);

      final borderRadiusGeometry = _decoration.borderRadius ?? (_decoration.shape == BoxShape.circle ? BorderRadius.circular(rect.longestSide) : BorderRadius.zero);
      final borderRadius = borderRadiusGeometry.resolve(textDirection);

      final clipRRect = borderRadius.toRRect(rect);

      final innerRect = rect.deflate(boxShadow.spreadRadius);
      if (innerRect.isEmpty) {
        final paint = Paint()..color = color;
        canvas.drawRRect(clipRRect, paint);
      }

      final innerRRect = borderRadius.toRRect(innerRect);

      canvas
        ..save()
        ..clipRRect(clipRRect);

      final outerRect = _areaCastingShadowInHole(rect, boxShadow);

      canvas
        ..drawDRRect(
          RRect.fromRectAndRadius(outerRect, Radius.zero),
          innerRRect.shift(boxShadow.offset),
          Paint()
            ..color = color
            ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, boxShadow.blurSigma),
        )
        ..restore();
    }
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  /// Paint the box decoration into the given location on the given canvas.
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final rect = offset & configuration.size!;
    final textDirection = configuration.textDirection;
    _paintOuterShadows(canvas, rect, textDirection);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintBackgroundImage(canvas, rect, configuration);
    _paintInnerShadows(canvas, rect, textDirection);
    _decoration.border?.paint(
      canvas,
      rect,
      shape: _decoration.shape,
      borderRadius: _decoration.borderRadius?.resolve(textDirection),
      textDirection: configuration.textDirection,
    );
  }

  @override
  String toString() {
    return '_InsetBoxDecorationPainter for $_decoration';
  }
}

Rect _areaCastingShadowInHole(Rect holeRect, BoxShadow shadow) {
  var bounds = holeRect;
  bounds = bounds.inflate(shadow.blurRadius);

  if (shadow.spreadRadius < 0) {
    bounds = bounds.inflate(-shadow.spreadRadius);
  }

  final offsetBounds = bounds.shift(shadow.offset);

  return _unionRects(bounds, offsetBounds);
}

Rect _unionRects(Rect a, Rect b) {
  if (a.isEmpty) {
    return b;
  }

  if (b.isEmpty) {
    return a;
  }

  final left = math.min(a.left, b.left);
  final top = math.min(a.top, b.top);
  final right = math.max(a.right, b.right);
  final bottom = math.max(a.bottom, b.bottom);

  return Rect.fromLTRB(left, top, right, bottom);
}

class BoxShadow extends painting.BoxShadow {
  const BoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    super.spreadRadius,
    super.blurStyle,
    this.inset = false,
  });

  /// Wether this shadow should be inset or not.
  final bool inset;

  /// Returns a new box shadow with its offset, blurRadius, and spreadRadius scaled by the given factor.
  @override
  BoxShadow scale(double factor) {
    return BoxShadow(
      color: color,
      offset: offset * factor,
      blurRadius: blurRadius * factor,
      spreadRadius: spreadRadius * factor,
      blurStyle: blurStyle,
      inset: inset,
    );
  }

  /// Linearly interpolate between two box shadows.
  ///
  /// If either box shadow is null, this function linearly interpolates from a
  /// a box shadow that matches the other box shadow in color but has a zero
  /// offset and a zero blurRadius.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static BoxShadow? lerp(BoxShadow? a, BoxShadow? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    if (a == null) {
      return b!.scale(t);
    }
    if (b == null) {
      return a.scale(1.0 - t);
    }

    final blurStyle = a.blurStyle == BlurStyle.normal ? b.blurStyle : a.blurStyle;

    if (a.inset != b.inset) {
      return BoxShadow(
        color: lerpColorWithPivot(a.color, b.color, t),
        offset: lerpOffsetWithPivot(a.offset, b.offset, t),
        blurRadius: lerpDoubleWithPivot(a.blurRadius, b.blurRadius, t),
        spreadRadius: lerpDoubleWithPivot(a.spreadRadius, b.spreadRadius, t),
        blurStyle: blurStyle,
        inset: t >= 0.5 ? b.inset : a.inset,
      );
    }

    return BoxShadow(
      color: Color.lerp(a.color, b.color, t)!,
      offset: Offset.lerp(a.offset, b.offset, t)!,
      blurRadius: ui.lerpDouble(a.blurRadius, b.blurRadius, t)!,
      spreadRadius: ui.lerpDouble(a.spreadRadius, b.spreadRadius, t)!,
      blurStyle: blurStyle,
      inset: b.inset,
    );
  }

  static List<BoxShadow>? lerpList(
    List<BoxShadow>? a,
    List<BoxShadow>? b,
    double t,
  ) {
    if (a == null || b == null) {
      return null;
    }

    final int commonLength = math.min(a.length, b.length);
    return <BoxShadow>[
      for (int i = 0; i < commonLength; i += 1) BoxShadow.lerp(a[i], b[i], t)!,
      for (int i = commonLength; i < a.length; i += 1) a[i].scale(1.0 - t),
      for (int i = commonLength; i < b.length; i += 1) b[i].scale(t),
    ];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BoxShadow &&
        other.color == color &&
        other.offset == offset &&
        other.blurRadius == blurRadius &&
        other.spreadRadius == spreadRadius &&
        other.blurStyle == blurStyle &&
        other.inset == inset;
  }

  @override
  int get hashCode => Object.hash(color, offset, blurRadius, spreadRadius, blurStyle, inset);

  @override
  String toString() => 'BoxShadow($color, $offset, ${debugFormatDouble(blurRadius)}, ${debugFormatDouble(spreadRadius)}), $blurStyle, $inset)';
}

double lerpDoubleWithPivot(num? a, num? b, double t) {
  if (t < 0.5) {
    return ui.lerpDouble(a, 0, t * 2)!;
  }

  return ui.lerpDouble(0, b, (t - 0.5) * 2)!;
}

Offset lerpOffsetWithPivot(Offset? a, Offset? b, double t) {
  if (t < 0.5) {
    return Offset.lerp(a, Offset.zero, t * 2)!;
  }

  return Offset.lerp(Offset.zero, b, (t - 0.5) * 2)!;
}

Color lerpColorWithPivot(Color? a, Color? b, double t) {
  if (t < 0.5) {
    return Color.lerp(a, a?.withOpacity(0), t * 2)!;
  }

  return Color.lerp(b?.withOpacity(0), b, (t - 0.5) * 2)!;
}

class InsetButton extends StatelessWidget {
  const InsetButton({super.key, this.onTap, this.isInset});

  final VoidCallback? onTap;
  final bool? isInset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xffe7ecef),
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: const Offset(-28, -28),
              color: Colors.white,
              inset: isInset ?? false,
            ),
            BoxShadow(blurRadius: 30, offset: const Offset(28, 28), color: const Color(0xffa7a9af), inset: isInset ?? false),
          ],
        ),
        child: const SizedBox(
          height: 200,
        ),
      ),
    );
  }
}
