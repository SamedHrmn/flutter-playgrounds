import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_birthday_page.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_password_page.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_phone_and_email_page.dart';

enum OnboardPages {
  authOnboardPhoneAndEmailPage,
  authOnboardPasswordPage,
  authOnboardBirthDayPage;

  Widget toPage() {
    switch (this) {
      case OnboardPages.authOnboardPhoneAndEmailPage:
        return const AuthOnboardPhoneOrEmailPage();
      case OnboardPages.authOnboardPasswordPage:
        return const AuthOnboardPasswordPage();
      case OnboardPages.authOnboardBirthDayPage:
        return const AuthOnboardBirthdayPage();
    }
  }
}
