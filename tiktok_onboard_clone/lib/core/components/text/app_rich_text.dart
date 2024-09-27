import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:tiktok_onboard_clone/core/constant/asset_constants.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';

class AppRichText extends StatelessWidget {
  const AppRichText({
    required this.text,
    super.key,
    this.defaultStyle,
    this.tags,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final Map<String, StyledTextTagBase>? tags;
  final TextStyle? defaultStyle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return StyledText(
      text: text,
      tags: tags,
      textAlign: textAlign,
      style: defaultStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: AppSizer.scaleWidth(16),
                fontFamily: AssetConstants.fontFamily,
              ),
    );
  }
}
