import 'package:flutter/material.dart';

final class SizerUtil {
  const SizerUtil._();

  static MediaQueryData? _mediaQueryData;
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static void init(BuildContext context, {required double figmaWidth, required double figmaHeight}) {
    _mediaQueryData = MediaQuery.of(context);
    if (_mediaQueryData != null) {
      _screenWidth = _mediaQueryData!.size.width;
      _screenHeight = _mediaQueryData!.size.height;

      _blockSizeHorizontal = _screenWidth / figmaWidth;
      _blockSizeVertical = _screenHeight / figmaHeight;
    }
  }

  static double scaleWidth(double width) {
    return width * _blockSizeHorizontal;
  }

  static double scaleHeight(double height) {
    return height * _blockSizeVertical;
  }

  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;

  static EdgeInsets padAll(double v) => EdgeInsets.all(scaleHeight(v));
  static EdgeInsets padHorizontal(double v) => EdgeInsets.symmetric(horizontal: scaleWidth(v));
  static EdgeInsets padVertical(double v) => EdgeInsets.symmetric(vertical: scaleHeight(v));

  static Duration get durationSwitcher => Durations.long4;
  static BorderRadius get borderRadius => BorderRadius.circular(12);

  static double get videoHeight => scaleHeight(250);
}
