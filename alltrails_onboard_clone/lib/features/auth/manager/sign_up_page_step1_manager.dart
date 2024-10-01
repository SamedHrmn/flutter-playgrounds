import 'package:alltrails_onboard_clone/features/auth/inherited/sign_up_view_inhterited.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step1.dart';
import 'package:flutter/material.dart';

mixin SignUpPageStep1Manager on State<SignUpPageStep1> {
  final formKey = GlobalKey<FormState>();

  Future<void> onNext() async {
    if (formKey.currentState!.validate()) {
      SignUpViewInhterited.of(context)?.nextPage();
    }
  }
}
