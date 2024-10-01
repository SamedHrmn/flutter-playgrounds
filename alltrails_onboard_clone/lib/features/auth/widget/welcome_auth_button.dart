import 'package:alltrails_onboard_clone/core/components/button/primary_button.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:flutter/material.dart';

class WelcomeAuthButton extends StatelessWidget {
  const WelcomeAuthButton._({
    super.key,
    required this.text,
    this.textColor,
    this.iconPath,
    this.onPressed,
    required this.buttonColor,
  });

  factory WelcomeAuthButton.icon({
    Key? key,
    required String text,
    Color? textColor,
    Future<void> Function()? onPressed,
    required String iconPath,
    required Color buttonColor,
  }) =>
      WelcomeAuthButton._(
        key: key,
        text: text,
        textColor: textColor,
        onPressed: onPressed,
        iconPath: iconPath,
        buttonColor: buttonColor,
      );

  factory WelcomeAuthButton.text({
    Key? key,
    required String text,
    required Color buttonColor,
    Color? textColor,
    Future<void> Function()? onPressed,
  }) =>
      WelcomeAuthButton._(
        key: key,
        text: text,
        textColor: textColor,
        buttonColor: buttonColor,
        onPressed: onPressed,
      );

  final String text;
  final String? iconPath;
  final Color? textColor;
  final Color buttonColor;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizer.scaleHeight(55),
      child: PrimaryButton(
        radius: 24,
        onPressed: onPressed,
        buttonColor: buttonColor,
        padding: AppSizer.horizontalPadding(12),
        child: Row(
          mainAxisAlignment: iconPath != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...{
              Container(
                padding: AppSizer.allPadding(4),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.background,
                ),
                child: Image.asset(
                  iconPath!,
                  width: AppSizer.scaleWidth(22),
                ),
              ),
            },
            AppText(
              text: text,
              color: textColor,
              fontSize: 18,
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
