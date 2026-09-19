import 'dart:math' as math;
import 'dart:ui' as ui show lerpDouble;

import 'package:custom_widgets/wallet_cards/wallet_metrics.dart';
import 'package:flutter/material.dart';

/// Chops [source] into evenly spaced segments so a stroke reads as stitching.
Path _dashed(Path source, {required double dash, required double gap}) {
  final result = Path();
  for (final metric in source.computeMetrics()) {
    var distance = 0.0;
    while (distance < metric.length) {
      final end = math.min(distance + dash, metric.length);
      result.addPath(metric.extractPath(distance, end), Offset.zero);
      distance = end + gap;
    }
  }
  return result;
}

/// Deep blue field with a violet halo behind the wallet. [glow] drives how hot
/// that halo burns, so it can brighten as the cards come out.
class WalletBackdropPainter extends CustomPainter {
  const WalletBackdropPainter({required this.glow});

  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas
      // Blue field, deepening towards the corners.
      ..drawRect(
        rect,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(0, -0.1),
            radius: 0.9,
            colors: [
              Color(0xFF5A28E4),
              Color(0xFF4422D2),
              Color(0xFF2D1EB8),
              Color(0xFF1C1B98),
              Color(0xFF151785),
            ],
            stops: [0, 0.3, 0.55, 0.8, 1],
          ).createShader(rect),
      )
      // Violet halo burning right behind the wallet.
      ..drawRect(
        rect,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0, -0.05),
            radius: 0.52,
            colors: [
              const Color(0xFFB93CFF).withValues(alpha: 0.85 * glow),
              const Color(0xFF7A2BF0).withValues(alpha: 0.45 * glow),
              const Color(0xFF7A2BF0).withValues(alpha: 0),
            ],
            stops: const [0, 0.5, 1],
          ).createShader(rect),
      );
  }

  @override
  bool shouldRepaint(WalletBackdropPainter oldDelegate) =>
      oldDelegate.glow != glow;
}

/// The dark slab the cards rest against, plus the shadow the whole wallet
/// casts onto the backdrop.
class WalletBackPanelPainter extends CustomPainter {
  const WalletBackPanelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const panel = WalletMetrics.backPanel;
    final rounded = RRect.fromRectAndRadius(
      panel,
      const Radius.circular(WalletMetrics.backRadius),
    );

    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          WalletMetrics.pocket.inflate(8).shift(const Offset(0, 30)),
          const Radius.circular(WalletMetrics.pocketRadius),
        ),
        Paint()
          ..color = const Color(0xFF07042A).withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 36),
      )
      ..drawRRect(
        rounded,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF272020), Color(0xFF14100F), Color(0xFF0A0808)],
            stops: [0, 0.5, 1],
          ).createShader(panel),
      )
      ..save()
      ..clipRRect(rounded)
      ..drawRRect(
        rounded.deflate(1),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.14),
              Colors.white.withValues(alpha: 0),
            ],
            stops: const [0, 0.3],
          ).createShader(panel),
      )
      ..restore();
  }

  @override
  bool shouldRepaint(WalletBackPanelPainter oldDelegate) => false;
}

/// The leather front pocket: body gradient, rim light, dashed stitching and the
/// embossed ring. Painted over the cards so they appear to slot inside.
class WalletPocketPainter extends CustomPainter {
  const WalletPocketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const rect = WalletMetrics.pocket;
    final rounded = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(WalletMetrics.pocketRadius),
    );

    canvas
      // Occlusion shadow where the cards dive into the mouth of the pocket.
      ..drawRRect(
        rounded.shift(const Offset(0, -14)),
        Paint()
          ..color = Colors.black.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      )
      ..drawRRect(
        rounded.shift(const Offset(0, 20)),
        Paint()
          ..color = const Color(0xFF07042A).withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28),
      )
      ..drawRRect(
        rounded,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3B322B), Color(0xFF29231F), Color(0xFF191513)],
            stops: [0, 0.45, 1],
          ).createShader(rect),
      )
      ..drawRRect(
        rounded,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.1,
            colors: [
              Colors.white.withValues(alpha: 0.035),
              Colors.white.withValues(alpha: 0),
            ],
          ).createShader(rect),
      )
      ..save()
      ..clipRRect(rounded)
      ..drawRRect(
        rounded.deflate(1.2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.26),
              Colors.white.withValues(alpha: 0),
            ],
            stops: const [0, 0.32],
          ).createShader(rect),
      )
      ..restore();

    _paintStitching(canvas);
    _paintEmboss(canvas);
  }

  void _paintStitching(Canvas canvas) {
    final seam = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          WalletMetrics.pocket.deflate(WalletMetrics.stitchInset),
          const Radius.circular(WalletMetrics.stitchRadius),
        ),
      );
    final dashes = _dashed(seam, dash: 11, gap: 9);

    canvas
      ..drawPath(
        dashes.shift(const Offset(0, -1.6)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = Colors.black.withValues(alpha: 0.35),
      )
      ..drawPath(
        dashes,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF93857B).withValues(alpha: 0.42),
      );
  }

  void _paintEmboss(Canvas canvas) {
    const center = WalletMetrics.embossCenter;
    const radius = WalletMetrics.embossRadius;

    canvas
      ..drawCircle(
        center.translate(0, -2.5),
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      )
      ..drawCircle(
        center.translate(0, 3),
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..color = Colors.white.withValues(alpha: 0.07)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
  }

  @override
  bool shouldRepaint(WalletPocketPainter oldDelegate) => false;
}

const _streakAngle = 0.52;

/// Static diagonal streaks baked into a card face, drawn behind its content.
class WalletCardFacePainter extends CustomPainter {
  const WalletCardFacePainter({required this.color, required this.sheen});

  /// Centre and half width of each streak, as a fraction of the half diagonal.
  static const _streaks = <(double, double)>[
    (-0.66, 0.075),
    (-0.32, 0.038),
    (0.06, 0.09),
    (0.46, 0.05),
  ];

  final Color color;
  final double sheen;

  @override
  void paint(Canvas canvas, Size size) {
    final diagonal = math.sqrt(
      size.width * size.width + size.height * size.height,
    );

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(_streakAngle);

    for (final streak in _streaks) {
      _paintBand(
        canvas,
        diagonal: diagonal,
        center: streak.$1 * diagonal / 2,
        halfWidth: streak.$2 * diagonal / 2,
        color: color,
        opacity: sheen,
      );
    }

    canvas.restore();
  }

  /// A CustomPaint asks its painters first and treats a null answer as a hit,
  /// so without this the card face would swallow taps aimed at the tappable
  /// strip nested inside it.
  @override
  bool? hitTest(Offset position) => false;

  @override
  bool shouldRepaint(WalletCardFacePainter oldDelegate) =>
      oldDelegate.sheen != sheen || oldDelegate.color != color;
}

/// The gloss that travels across a card as it leaves the pocket.
class WalletCardSweepPainter extends CustomPainter {
  const WalletCardSweepPainter({
    required this.color,
    required this.progress,
    required this.bend,
  });

  final Color color;
  final double progress;

  /// 0 while the card lies flat, 1 once it is bowed out of the stack.
  final double bend;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBow(canvas, size);
    _paintSweep(canvas, size);
  }

  /// A tilt alone reads as a flat card on an angle. Shading the long edges into
  /// shadow and catching light down the middle is what sells an actual bow,
  /// since a single matrix cannot curve the surface itself.
  void _paintBow(Canvas canvas, Size size) {
    final amount = bend.clamp(0.0, 1.0);
    if (amount <= 0) return;

    final rect = Offset.zero & size;

    canvas
      ..drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.34 * amount),
              Colors.black.withValues(alpha: 0),
              Colors.black.withValues(alpha: 0),
              Colors.black.withValues(alpha: 0.34 * amount),
            ],
            stops: const [0, 0.26, 0.74, 1],
          ).createShader(rect),
      )
      ..drawRect(
        rect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.16 * amount),
              Colors.white.withValues(alpha: 0),
            ],
            stops: const [0.28, 0.5, 0.72],
          ).createShader(rect),
      );
  }

  void _paintSweep(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final diagonal = math.sqrt(
      size.width * size.width + size.height * size.height,
    );

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(_streakAngle);

    _paintBand(
      canvas,
      diagonal: diagonal,
      center: ui.lerpDouble(-0.95, 0.95, progress)! * diagonal / 2,
      halfWidth: 0.11 * diagonal / 2,
      color: color,
      opacity: 0.3 * math.sin(math.pi * progress),
    );

    canvas.restore();
  }

  /// See [WalletCardFacePainter.hitTest] - the gloss must stay transparent to
  /// pointers too, since it sits in front of the card content.
  @override
  bool? hitTest(Offset position) => false;

  @override
  bool shouldRepaint(WalletCardSweepPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.bend != bend ||
      oldDelegate.color != color;
}

/// Draws one soft-edged vertical band in the already rotated canvas space.
void _paintBand(
  Canvas canvas, {
  required double diagonal,
  required double center,
  required double halfWidth,
  required Color color,
  required double opacity,
}) {
  if (opacity <= 0) return;

  final rect = Rect.fromLTRB(
    center - halfWidth,
    -diagonal,
    center + halfWidth,
    diagonal,
  );

  canvas.drawRect(
    rect,
    Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: 0),
          color.withValues(alpha: opacity),
          color.withValues(alpha: 0),
        ],
      ).createShader(rect),
  );
}
