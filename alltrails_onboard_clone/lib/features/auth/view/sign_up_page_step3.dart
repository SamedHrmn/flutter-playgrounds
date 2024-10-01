import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/features/auth/manager/sign_up_page_step3_manager.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/sign_up_text_field.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/welcome_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/tags/styled_text_tag.dart';

class SignUpPageStep3 extends StatefulWidget {
  const SignUpPageStep3({super.key});

  @override
  State<SignUpPageStep3> createState() => _SignUpPageStep3State();
}

class _SignUpPageStep3State extends State<SignUpPageStep3> with SignUpPageStep3Manager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EmptyBox(
              height: 24,
            ),
            pageTitle(),
            const EmptyBox(
              height: 16,
            ),
            firstNameField(),
            const EmptyBox(
              height: 24,
            ),
            lastNameField(),
            const EmptyBox(
              height: 16,
            ),
            privacyPolicyRichText(context),
            Expanded(
              child: nextButton(),
            ),
            const EmptyBox(
              height: 32,
            ),
            EmptyBox(
              height: AppSizer.scaleHeight(
                AppSizer.screenHeight * 0.65,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Align nextButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: WelcomeAuthButton.text(
        text: StringConstantEnum.signUpPagesButtonText.name,
        onPressed: onNext,
        buttonColor: ColorConstants.primary2,
      ),
    );
  }

  AppRichText privacyPolicyRichText(BuildContext context) {
    return AppRichText(
      text: StringConstantEnum.welcomePrivacyPolicyText.name,
      textAlign: TextAlign.start,
      defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorConstants.primary1.withOpacity(0.5),
            fontSize: AppSizer.scaleWidth(14),
          ),
      tags: {
        'b': StyledTextTag(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                color: ColorConstants.primary1,
                fontSize: AppSizer.scaleWidth(14),
              ),
        ),
      },
    );
  }

  SignUpTextField lastNameField() {
    return SignUpTextField(
      labelText: StringConstantEnum.signUpPagesLastNameHint.name,
    );
  }

  SignUpTextField firstNameField() {
    return SignUpTextField(
      labelText: StringConstantEnum.signUpPagesFirstNameHint.name,
    );
  }

  AppText pageTitle() {
    return AppText(
      text: StringConstantEnum.signUpPagesNameTitle.name,
      fontSize: 24,
      color: ColorConstants.textBlack,
    );
  }
}
