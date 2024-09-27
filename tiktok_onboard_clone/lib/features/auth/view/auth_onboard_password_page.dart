import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/app_text_form_field.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/auth_onboard_password_page_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/onboard_next_button.dart';

class AuthOnboardPasswordPage extends StatefulWidget {
  const AuthOnboardPasswordPage({super.key});

  @override
  State<AuthOnboardPasswordPage> createState() => _AuthOnboardPasswordPageState();
}

class _AuthOnboardPasswordPageState extends State<AuthOnboardPasswordPage> with AuthOnboardPasswordPageManager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final buttonIsActive = isValidLength() && isVaildLetterAndNumber() && isValidSpecialChar();

    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EmptyBox(
            height: 32,
          ),
          createPasswordText(context),
          passwordTextFormField(context),
          passwordMustHaveColumn(context),
          const EmptyBox(
            height: 24,
          ),
          nextButton(buttonIsActive, context),
        ],
      ),
    );
  }

  AppText createPasswordText(BuildContext context) {
    return AppText(
      text: LocalizationKeys.signUpCreatePassword.name.tr(context: context),
      fontSize: 20,
      appTextWeight: AppTextWeight.bold,
    );
  }

  AppTextFormField passwordTextFormField(BuildContext context) {
    return AppTextFormField(
      onChanged: updatePassword,
      hintText: LocalizationKeys.signUpCreatePasswordHintText.name.tr(context: context),
    );
  }

  Column passwordMustHaveColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EmptyBox(
          height: 16,
        ),
        AppText(
          text: LocalizationKeys.signUpCreatePasswordHaveMustText.name.tr(context: context),
          fontSize: 15,
        ),
        const EmptyBox(height: 8),
        _PasswordMustHaveItem(
          text: LocalizationKeys.signUpCreatePasswordValidatingText1.name.tr(context: context),
          success: isValidLength(),
        ),
        const EmptyBox(height: 4),
        _PasswordMustHaveItem(
          text: LocalizationKeys.signUpCreatePasswordValidatingText2.name.tr(context: context),
          success: isVaildLetterAndNumber(),
        ),
        const EmptyBox(height: 4),
        _PasswordMustHaveItem(
          text: LocalizationKeys.signUpCreatePasswordValidatingText3.name.tr(context: context),
          success: isValidSpecialChar(),
        ),
      ],
    );
  }

  Widget nextButton(bool buttonIsActive, BuildContext context) {
    return OnboardNextButton(
      buttonIsActive: buttonIsActive,
      onPressed: () async => goNextPage(),
    );
  }
}

class _PasswordMustHaveItem extends StatelessWidget {
  const _PasswordMustHaveItem({
    required this.text,
    required this.success,
  });

  final String text;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 2,
              color: success ? ColorConstants.primary : ColorConstants.textSecondary,
            ),
          ),
          child: Icon(
            Icons.check,
            color: success ? ColorConstants.primary : ColorConstants.textSecondary,
            size: AppSizer.scaleWidth(16),
          ),
        ),
        const EmptyBox(width: 4),
        AppText(
          text: text,
          color: ColorConstants.textSecondary,
          fontSize: 14,
        ),
      ],
    );
  }
}
