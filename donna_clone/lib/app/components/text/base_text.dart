import 'package:flutter/material.dart';

enum AppTextWeight {
  regular,
  medium,
  semibold,
  bold,
  extrabold;

  FontWeight toWeight() {
    switch (this) {
      case AppTextWeight.regular:
        return FontWeight.w400;
      case AppTextWeight.medium:
        return FontWeight.w500;
      case AppTextWeight.semibold:
        return FontWeight.w600;
      case AppTextWeight.bold:
        return FontWeight.w700;
      case AppTextWeight.extrabold:
        return FontWeight.w800;
    }
  }
}

class BaseText extends StatelessWidget {
  const BaseText({
    required this.text,
    super.key,
    this.appTextWeight = AppTextWeight.medium,
    this.fontSize = 16.0,
    this.fontFamily,
    this.height,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.textDecoration,
    this.color,
    this.isOverflow = false,
  });

  final String text;
  final String? fontFamily;
  final AppTextWeight appTextWeight;
  final double fontSize;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDecoration? textDecoration;
  final Color? color;
  final bool isOverflow;
  final double? height;

  TextStyle get style => TextStyle(
        fontWeight: appTextWeight.toWeight(),
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
        height: height,
        overflow: isOverflow ? TextOverflow.ellipsis : null,
        decoration: textDecoration,
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      style: style,
    );
  }
}
