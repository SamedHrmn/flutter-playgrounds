import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/core/util/form_validators.dart';
import 'package:alltrails_onboard_clone/features/auth/manager/sign_up_page_step2_manager.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/sign_up_text_field.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/welcome_auth_button.dart';
import 'package:flutter/material.dart';

class SignUpPageStep2 extends StatefulWidget {
  const SignUpPageStep2({super.key});

  @override
  State<SignUpPageStep2> createState() => _SignUpPageStep2State();
}

class _SignUpPageStep2State extends State<SignUpPageStep2> with SignUpPageStep2Manager, AutomaticKeepAliveClientMixin {
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
            passwordTextField(),
            const EmptyBox(
              height: 16,
            ),
            showPasswordRow(),
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

  Row showPasswordRow() {
    return Row(
      children: [
        Checkbox(
          value: !isObscureText,
          onChanged: updateShowPassword,
          activeColor: ColorConstants.primary2,
          side: const BorderSide(color: ColorConstants.secondary1),
          visualDensity: VisualDensity.compact,
        ),
        AppText(
          text: StringConstantEnum.signUpPagesShowPassword.name,
          color: ColorConstants.primary1.withOpacity(0.5),
          appTextWeight: AppTextWeight.regular,
        ),
      ],
    );
  }

  SignUpTextField passwordTextField() {
    return SignUpTextField(
      labelText: StringConstantEnum.signUpPagesPasswordHint.name,
      validator: validatePassword,
      obscureText: isObscureText,
    );
  }

  AppText pageTitle() {
    return AppText(
      text: StringConstantEnum.signUpPagesPasswordTitle.name,
      fontSize: 24,
      color: ColorConstants.textBlack,
    );
  }
}
