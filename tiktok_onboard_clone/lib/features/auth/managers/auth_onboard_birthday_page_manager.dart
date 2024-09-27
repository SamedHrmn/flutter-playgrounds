import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_birthday_page.dart';

mixin AuthOnboardBirthdayPageManager on State<AuthOnboardBirthdayPage> {
  DateTime? birthDay;

  void updateBirthDay(DateTime? date) {
    setState(() {
      birthDay = date;
    });
  }
}
