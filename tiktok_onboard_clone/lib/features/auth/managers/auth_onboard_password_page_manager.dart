import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/features/auth/inherited/auth_onboard_view_inherited.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_password_page.dart';

mixin AuthOnboardPasswordPageManager on State<AuthOnboardPasswordPage> {
  String password = '';

  void updatePassword(String v) {
    setState(() {
      password = v;
    });
  }

  void goNextPage() {
    AuthOnboardViewInherited.of(context)!.pageController.nextPage(duration: Durations.short1, curve: Curves.linear);
  }

  bool isValidLength() {
    if (password.length >= 8 && password.length <= 20) return true;
    return false;
  }

  bool isVaildLetterAndNumber() {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(password);
  }

  bool isValidSpecialChar() {
    return RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(password);
  }
}
