import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/button/primary_button.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';

class AuthButton extends StatefulWidget {
  const AuthButton._({required this.text, this.imagePath, this.iconData, this.onPressed});

  factory AuthButton.image({
    required String text,
    required String imagePath,
    Future<void> Function()? onPressed,
  }) {
    return AuthButton._(
      text: text,
      imagePath: imagePath,
      onPressed: onPressed,
    );
  }
  factory AuthButton.icon({
    required String text,
    required IconData iconData,
    Future<void> Function()? onPressed,
  }) {
    return AuthButton._(
      text: text,
      iconData: iconData,
      onPressed: onPressed,
    );
  }

  final String text;
  final String? imagePath;
  final IconData? iconData;
  final Future<void> Function()? onPressed;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool pressed = false;

  void updatePressedState(bool v) {
    setState(() {
      pressed = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizer.scaleHeight(60),
      child: PrimaryButton(
        padding: AppSizer.horizontalPadding(16),
        pressedState: updatePressedState,
        pressedOverlayColor: ColorConstants.primary,
        onPressed: widget.onPressed,
        radius: 0,
        borderSide: const BorderSide(color: ColorConstants.textSecondary),
        buttonColor: ColorConstants.background,
        child: Row(
          children: [
            if (widget.iconData != null) ...{
              Icon(
                widget.iconData,
                color: ColorConstants.textBlack,
                size: AppSizer.scaleWidth(32),
              ),
            } else if (widget.imagePath != null) ...{
              Image.asset(
                widget.imagePath!,
                height: AppSizer.scaleHeight(32),
              ),
            },
            const Spacer(
              flex: 2,
            ),
            AppText(
              text: widget.text,
              color: pressed ? ColorConstants.textWhite : null,
            ),
            const Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
