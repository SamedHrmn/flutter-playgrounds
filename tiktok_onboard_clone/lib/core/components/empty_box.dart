import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? AppSizer.scaleWidth(width!) : null,
      height: height != null ? AppSizer.scaleHeight(height!) : null,
    );
  }
}
