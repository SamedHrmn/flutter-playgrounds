import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/constant/asset_constants.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';

final class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ColorConstants.textBlack,
        fontFamily: AssetConstants.fontFamily,
      ),
    ),
  );
}
