import 'package:flutter/material.dart';

final class AppSizer {
  const AppSizer._();

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

  static EdgeInsets get pageHorizontalPadding => EdgeInsets.symmetric(horizontal: scaleWidth(32));
  static EdgeInsets horizontalPadding(double v) => EdgeInsets.symmetric(horizontal: scaleWidth(v));
  static EdgeInsets allPadding(double v) => EdgeInsets.all(scaleWidth(v));
  static EdgeInsets padOnly({double l = 0, double r = 0, double t = 0, double b = 0}) => EdgeInsets.only(
        left: scaleWidth(l),
        right: scaleWidth(r),
        top: scaleHeight(t),
        bottom: scaleHeight(b),
      );
}
