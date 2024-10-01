import 'package:alltrails_onboard_clone/core/constants/asset_constants.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:flutter/material.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData defaultTheme = ThemeData.light().copyWith(
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: AssetConstants.fontFamily,
        color: ColorConstants.textWhite,
        fontWeight: FontWeight.w500,
        fontSize: AppSizer.scaleWidth(16),
      ),
    ),
  );
}
