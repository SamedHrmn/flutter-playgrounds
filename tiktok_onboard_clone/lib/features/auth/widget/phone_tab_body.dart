import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/phone_tab_body_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/onboard_next_button.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/phone_number_input_field.dart';

class PhoneTabBody extends StatefulWidget {
  const PhoneTabBody({super.key});

  @override
  State<PhoneTabBody> createState() => _PhoneTabBodyState();
}

class _PhoneTabBodyState extends State<PhoneTabBody> with PhoneTabBodyManager {
  @override
  Widget build(BuildContext context) {
    final buttonIsActive = dialCode.isNotEmpty && phoneNumber.isNotEmpty;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const EmptyBox(height: 48),
          PhoneNumberInputField(
            onCountryAndDialCodeChanged: (_, dialCode) {
              updateDialCode(dialCode);
            },
            onPhoneChanged: updatePhoneNumber,
          ),
          const EmptyBox(
            height: 24,
          ),
          AppRichText(
            textAlign: TextAlign.start,
            text: LocalizationKeys.signUpPhoneFieldBottomText.name.tr(context: context),
            defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstants.textSecondary,
                  fontSize: AppSizer.scaleWidth(15),
                  fontWeight: FontWeight.w400,
                ),
            tags: {
              'b': StyledTextTag(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstants.textSecondary2,
                      fontSize: AppSizer.scaleWidth(15),
                      fontWeight: FontWeight.w400,
                    ),
              ),
            },
          ),
          const EmptyBox(
            height: 24,
          ),
          OnboardNextButton(
            buttonIsActive: buttonIsActive,
            text: LocalizationKeys.signUpPhoneFieldSendCode.name.tr(context: context),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                goNextPage(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
