import 'package:custom_widgets/wallet_cards/wallet_card_data.dart';
import 'package:flutter/material.dart';

const _mastercardRed = Color(0xFFEB001B);
const _mastercardAmber = Color(0xFFF79E1B);
const _mastercardOverlap = Color(0xFFFF5F00);
const _payPalNavy = Color(0xFF003087);
const _payPalSky = Color(0xFF009CDE);

/// Brand logo drawn entirely from paths and text - no image assets involved.
class WalletBrandMark extends StatelessWidget {
  const WalletBrandMark({required this.brand, super.key});

  final WalletBrand brand;

  @override
  Widget build(BuildContext context) {
    switch (brand) {
      case WalletBrand.mastercard:
        return const CustomPaint(
          size: Size(68, 40),
          painter: _MastercardPainter(),
        );

      case WalletBrand.visa:
        return const _Slanted(
          child: Text(
            'VISA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        );

      case WalletBrand.payPal:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(size: Size(37, 38), painter: _PayPalGlyphPainter()),
            SizedBox(width: 9),
            _Slanted(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Pay', style: TextStyle(color: _payPalNavy)),
                    TextSpan(text: 'Pal', style: TextStyle(color: _payPalSky)),
                  ],
                ),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1,
                ),
              ),
            ),
          ],
        );
    }
  }
}

/// Leans a wordmark to the right the way both the Visa and PayPal logotypes do.
class _Slanted extends StatelessWidget {
  const _Slanted({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.skewX(-0.16),
      child: child,
    );
  }
}

/// Two interlocking circles; the overlap is filled with the third brand colour.
class _MastercardPainter extends CustomPainter {
  const _MastercardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    final left = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      );
    final right = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width - radius, radius),
          radius: radius,
        ),
      );

    canvas
      ..drawPath(left, Paint()..color = _mastercardRed)
      ..drawPath(right, Paint()..color = _mastercardAmber)
      ..drawPath(
        Path.combine(PathOperation.intersect, left, right),
        Paint()..color = _mastercardOverlap,
      );
  }

  @override
  bool shouldRepaint(_MastercardPainter oldDelegate) => false;
}

/// The two overlapping `P` glyphs of the PayPal monogram.
class _PayPalGlyphPainter extends CustomPainter {
  const _PayPalGlyphPainter();

  /// Letterform described inside a 0..1 box so it can be scaled freely.
  static final Path _glyph = _buildGlyph();

  static Path _buildGlyph() {
    final body = Path()
      ..moveTo(0.14, 0)
      ..lineTo(0.56, 0)
      ..cubicTo(0.86, 0, 1, 0.17, 0.95, 0.41)
      ..cubicTo(0.90, 0.67, 0.68, 0.81, 0.42, 0.81)
      ..lineTo(0.28, 0.81)
      ..lineTo(0.22, 1)
      ..lineTo(0, 1)
      ..close();

    final counter = Path()
      ..moveTo(0.35, 0.20)
      ..lineTo(0.56, 0.20)
      ..cubicTo(0.73, 0.20, 0.79, 0.30, 0.74, 0.43)
      ..cubicTo(0.69, 0.56, 0.57, 0.61, 0.42, 0.61)
      ..lineTo(0.30, 0.61)
      ..close();

    return Path.combine(PathOperation.difference, body, counter);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Offset far enough apart that both counters stay legible; the sky-blue
    // glyph sits in front and slightly lower, as in the real monogram.
    _stamp(canvas, size, Offset.zero, 0.58, 1, _payPalNavy);
    _stamp(canvas, size, const Offset(0.43, 0.12), 0.57, 0.88, _payPalSky);
  }

  void _stamp(
    Canvas canvas,
    Size size,
    Offset origin,
    double scaleX,
    double scaleY,
    Color color,
  ) {
    canvas
      ..save()
      ..translate(origin.dx * size.width, origin.dy * size.height)
      ..scale(scaleX * size.width, scaleY * size.height)
      ..drawPath(_glyph, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_PayPalGlyphPainter oldDelegate) => false;
}
