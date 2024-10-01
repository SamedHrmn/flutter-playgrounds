import 'package:alltrails_onboard_clone/core/constants/asset_constants.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:flutter/material.dart';

enum AppTextWeight {
  light,
  regular,
  medium,
  semiBold,
  bold;

  FontWeight toWeight() {
    switch (this) {
      case AppTextWeight.light:
        return FontWeight.w300;
      case AppTextWeight.regular:
        return FontWeight.w400;
      case AppTextWeight.medium:
        return FontWeight.w500;
      case AppTextWeight.semiBold:
        return FontWeight.w600;
      case AppTextWeight.bold:
        return FontWeight.w700;
    }
  }
}

class AppText extends StatelessWidget {
  const AppText({
    required this.text,
    super.key,
    this.appTextWeight = AppTextWeight.medium,
    this.fontSize = 16.0,
    this.height,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.textDecoration,
    this.color,
    this.decorationColor,
    this.isOverflow = false,
  });

  final String text;
  final AppTextWeight appTextWeight;
  final double fontSize;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDecoration? textDecoration;
  final Color? color;
  final bool isOverflow;
  final double? height;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: appTextWeight.toWeight(),
            fontSize: AppSizer.scaleWidth(fontSize),
            color: color,
            fontFamily: AssetConstants.fontFamily,
            height: height,
            overflow: isOverflow ? TextOverflow.ellipsis : null,
            decorationColor: decorationColor,
            decoration: textDecoration,
          ),
    );
  }
}
