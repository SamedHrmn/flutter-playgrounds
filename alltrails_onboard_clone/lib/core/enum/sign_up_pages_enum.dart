import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step1.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step2.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step3.dart';
import 'package:flutter/material.dart';

enum SignUpPagesEnum {
  step1,
  step2,
  step3;

  const SignUpPagesEnum();

  Widget toWidget() {
    switch (this) {
      case SignUpPagesEnum.step1:
        return const SignUpPageStep1();
      case SignUpPagesEnum.step2:
        return const SignUpPageStep2();
      case SignUpPagesEnum.step3:
        return const SignUpPageStep3();
    }
  }
}
