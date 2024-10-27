import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/asset_constants.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/shared/widget/button/app_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Image.asset(
          AssetConstants.icTurnTable,
          height: AppSizer.scaleHeight(60),
          color: ColorConstants.primary2,
        ),
        const EmptyBox(
          height: 32,
        ),
        Column(
          children: [
            AppText(
              LocalizationKeys.libraryTitle1.name.tr(context: context),
              fontSize: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  " ${LocalizationKeys.libraryTitle2.name.tr(context: context)}",
                  fontSize: 24,
                ),
                Image.asset(
                  AssetConstants.icMicrophone,
                  height: AppSizer.scaleHeight(50),
                ),
              ],
            ),
          ],
        ),
        const EmptyBox(height: 60),
        Padding(
          padding: AppSizer.pageHorizontalPadding,
          child: AppButton(
            padding: AppSizer.padOnly(t: 16, b: 16),
            buttonColor: ColorConstants.primary2,
            radius: 16,
            child: AppText(
              LocalizationKeys.libraryButtonText.name.tr(context: context),
              appTextWeight: AppTextWeight.semibold,
              fontSize: 20,
            ),
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}
