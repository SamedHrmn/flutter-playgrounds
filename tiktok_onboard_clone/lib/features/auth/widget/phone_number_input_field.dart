import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/app_text_form_field.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/core/util/form_validators.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/phone_number_input_field_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/phone_country_picker_dialog.dart';

class PhoneNumberInputField extends StatefulWidget {
  const PhoneNumberInputField({super.key, this.onPhoneChanged, this.onCountryAndDialCodeChanged});

  final void Function(String phone)? onPhoneChanged;
  final void Function(String countryCode, String dialCode)? onCountryAndDialCodeChanged;

  @override
  _PhoneNumberInputFieldState createState() => _PhoneNumberInputFieldState();
}

class _PhoneNumberInputFieldState extends State<PhoneNumberInputField> with PhoneNumberInputFieldManager {
  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      validator: (phone) => validatePhoneNumber(phone, context),
      prefixIcon: prefixButton(context),
      hintText: LocalizationKeys.signUpPhoneNumberHintText.name.tr(context: context),
    );
  }

  InkWell prefixButton(BuildContext context) {
    return InkWell(
      onTap: () => _openCountryPicker(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(text: selectedCountryCode),
          const EmptyBox(width: 2),
          AppText(text: selectedCountryDial),
          Flexible(
            child: Padding(
              padding: AppSizer.horizontalPadding(4),
              child: Icon(
                Icons.arrow_drop_down,
                size: AppSizer.scaleWidth(20),
              ),
            ),
          ),
          Padding(
            padding: AppSizer.padOnly(r: 12),
            child: RotatedBox(
              quarterTurns: 1,
              child: SizedBox(
                height: 2,
                width: AppSizer.scaleHeight(16),
                child: const Divider(
                  color: ColorConstants.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCountryPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PhoneCountryPickerDialog(
          onItemSelected: (countryCode, dialCode) {
            updateSelectedCountryCodeAndDialCode(countryCode: countryCode, dialCode: dialCode);
          },
        );
      },
    );
  }
}
