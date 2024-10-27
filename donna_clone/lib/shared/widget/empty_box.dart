import 'package:donna_clone/app/components/base_box.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:flutter/material.dart';

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return BaseBox(
      width: width != null ? AppSizer.scaleWidth(width!) : null,
      height: height != null ? AppSizer.scaleHeight(height!) : null,
    );
  }
}
