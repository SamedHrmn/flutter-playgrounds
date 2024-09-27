import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/constant/country_dialing_codes.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/phone_number_input_field.dart';

mixin PhoneNumberInputFieldManager on State<PhoneNumberInputField> {
  late String selectedCountryCode;
  late String selectedCountryDial;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    selectedCountryCode = countryDataList.first['code']!;
    selectedCountryDial = countryDataList.first['dial_code']!;

    phoneController = TextEditingController();
    phoneController.addListener(() {
      widget.onPhoneChanged?.call(phoneController.value.text);
    });
  }

  void updateSelectedCountryCodeAndDialCode({required String countryCode, required String dialCode}) {
    setState(() {
      selectedCountryDial = dialCode;
      selectedCountryCode = countryCode;
    });
    widget.onCountryAndDialCodeChanged?.call(selectedCountryCode, selectedCountryDial);
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
