import 'package:flutter/material.dart';
import '../constant/color_constant.dart';
import '../util/sizer_util.dart';

class AppText extends StatelessWidget {
  const AppText(this.text, {super.key, this.color = ColorConstant.textBlack, this.fontSize = 16});

  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: SizerUtil.scaleHeight(fontSize), color: color),
    );
  }
}
