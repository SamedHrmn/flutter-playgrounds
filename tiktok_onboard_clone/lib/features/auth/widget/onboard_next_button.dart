import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/button/primary_button.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';

class OnboardNextButton extends StatelessWidget {
  const OnboardNextButton({required this.buttonIsActive, super.key, this.onPressed, this.text});

  final bool buttonIsActive;
  final String? text;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.short4,
      child: SizedBox(
        key: ValueKey(buttonIsActive),
        width: double.maxFinite,
        child: PrimaryButton(
          buttonColor: buttonIsActive ? ColorConstants.primary : ColorConstants.buttonDisabled,
          padding: AppSizer.padOnly(t: 12, b: 12),
          onPressed: !buttonIsActive ? null : onPressed,
          child: AppText(
            text: text ?? LocalizationKeys.nextButtonText.name.tr(context: context),
            color: buttonIsActive ? ColorConstants.textWhite : ColorConstants.textSecondary,
          ),
        ),
      ),
    );
  }
}
