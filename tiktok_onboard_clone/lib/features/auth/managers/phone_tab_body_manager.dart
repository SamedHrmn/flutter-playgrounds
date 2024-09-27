import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/constant/country_dialing_codes.dart';
import 'package:tiktok_onboard_clone/features/auth/inherited/auth_onboard_view_inherited.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/phone_tab_body.dart';

mixin PhoneTabBodyManager on State<PhoneTabBody> {
  final formKey = GlobalKey<FormState>();
  String dialCode = countryDataList.first['dial_code']!;
  String phoneNumber = '';

  void updateDialCode(String code) {
    setState(() {
      dialCode = code;
    });
  }

  void updatePhoneNumber(String number) {
    setState(() {
      phoneNumber = number;
    });
  }

  void goNextPage(BuildContext context) {
    AuthOnboardViewInherited.of(context)?.pageController.nextPage(duration: Durations.short1, curve: Curves.linear);
  }
}
