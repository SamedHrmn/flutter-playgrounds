import 'package:flutter/material.dart';

@immutable
final class SizeConstants {
  const SizeConstants._();

  static EdgeInsets pageOuterPadding() => const EdgeInsets.symmetric(vertical: 24, horizontal: 16);
  static BorderRadius borderRadiusGeneral() => BorderRadius.circular(16);
}
