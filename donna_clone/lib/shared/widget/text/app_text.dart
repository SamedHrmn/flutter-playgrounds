import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/asset_constants.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.appTextWeight = AppTextWeight.medium,
    this.fontSize = 16,
    this.textAlign = TextAlign.center,
    this.textDecoration,
    this.color,
    this.isOverflow = false,
    this.height,
    this.maxLines,
    this.fontFamily = AssetConstants.fontFamilyUto,
  });

  final String text;
  final AppTextWeight appTextWeight;
  final double fontSize;
  final TextAlign textAlign;
  final TextDecoration? textDecoration;
  final Color? color;
  final bool isOverflow;
  final double? height;
  final String fontFamily;
  final int? maxLines;

  TextStyle get textStyle => BaseText(text: text).style;

  @override
  Widget build(BuildContext context) {
    return BaseText(
      text: text,
      fontFamily: fontFamily,
      appTextWeight: appTextWeight,
      textAlign: textAlign,
      maxLines: maxLines,
      textDecoration: textDecoration,
      color: color ?? ColorConstants.textWhite,
      isOverflow: isOverflow,
      height: height,
      fontSize: AppSizer.scaleWidth(fontSize),
    );
  }
}
