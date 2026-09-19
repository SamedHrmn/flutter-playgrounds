import 'package:flutter/material.dart';

/// Payment brands rendered by `WalletBrandMark`. Every mark is drawn with
/// canvas primitives and text so the sample ships without image assets.
enum WalletBrand { mastercard, visa, payPal }

@immutable
class WalletCardData {
  const WalletCardData({
    required this.brand,
    required this.amount,
    required this.gradient,
    required this.foreground,
    required this.sheenColor,
    required this.sheen,
  });

  final WalletBrand brand;
  final double amount;
  final Gradient gradient;

  /// Colour of the balance label.
  final Color foreground;

  /// Tint of the diagonal streaks baked into the card face.
  final Color sheenColor;

  /// Opacity of those streaks.
  final double sheen;
}

/// Ordered back to front: the first entry ends up highest in the fanned stack,
/// the last one sits closest to the viewer.
const walletCardStack = <WalletCardData>[
  WalletCardData(
    brand: WalletBrand.mastercard,
    amount: 1005,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF26262A), Color(0xFF131316), Color(0xFF08080A)],
      stops: [0, 0.55, 1],
    ),
    foreground: Colors.white,
    sheenColor: Colors.white,
    sheen: 0.06,
  ),
  WalletCardData(
    brand: WalletBrand.visa,
    amount: 735,
    gradient: LinearGradient(
      begin: Alignment(-1, -0.7),
      end: Alignment(1, 0.7),
      colors: [
        Color(0xFFFF5AD6),
        Color(0xFFEE35C4),
        Color(0xFF8B34E6),
        Color(0xFF3A3BE6),
        Color(0xFF2430D8),
      ],
      stops: [0, 0.22, 0.55, 0.82, 1],
    ),
    foreground: Colors.white,
    sheenColor: Colors.white,
    sheen: 0.09,
  ),
  WalletCardData(
    brand: WalletBrand.payPal,
    amount: 4799,
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF4F4F8), Color(0xFFE7E7EF)],
      stops: [0, 0.6, 1],
    ),
    foreground: Color(0xFF111B3A),
    sheenColor: Color(0xFF9A9AB4),
    sheen: 0.1,
  ),
];
