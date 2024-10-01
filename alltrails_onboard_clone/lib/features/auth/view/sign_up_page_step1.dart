import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/core/util/form_validators.dart';
import 'package:alltrails_onboard_clone/features/auth/manager/sign_up_page_step1_manager.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/sign_up_text_field.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/welcome_auth_button.dart';
import 'package:flutter/material.dart';

class SignUpPageStep1 extends StatefulWidget {
  const SignUpPageStep1({super.key});

  @override
  State<SignUpPageStep1> createState() => _SignUpPageStep1State();
}

class _SignUpPageStep1State extends State<SignUpPageStep1> with SignUpPageStep1Manager, AutomaticKeepAliveClientMixin {
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
            emailTextField(),
            Expanded(
              child: nextButton(),
            ),
            EmptyBox(
              height: AppSizer.scaleHeight(
                AppSizer.screenHeight * 0.85,
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

  SignUpTextField emailTextField() {
    return SignUpTextField(
      labelText: StringConstantEnum.signUpPagesEmailHint.name,
      validator: validateEmail,
    );
  }

  AppText pageTitle() {
    return AppText(
      text: StringConstantEnum.signUpPagesEmailTitle.name,
      fontSize: 24,
      color: ColorConstants.textBlack,
    );
  }
}
