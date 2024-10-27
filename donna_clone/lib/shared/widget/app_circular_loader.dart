import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:flutter/material.dart';

class AppCircularLoader extends StatelessWidget {
  const AppCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: Padding(
        padding: AppSizer.allPadding(4),
        child: const CircularProgressIndicator(
          color: ColorConstants.primary2,
        ),
      ),
    );
  }
}
