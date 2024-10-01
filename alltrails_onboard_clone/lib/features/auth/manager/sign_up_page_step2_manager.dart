import 'package:alltrails_onboard_clone/features/auth/inherited/sign_up_view_inhterited.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step2.dart';
import 'package:flutter/material.dart';

mixin SignUpPageStep2Manager on State<SignUpPageStep2> {
  final formKey = GlobalKey<FormState>();
  bool isObscureText = false;

  void updateShowPassword(bool? _) {
    setState(() {
      isObscureText = !isObscureText;
    });
  }

  Future<void> onNext() async {
    if (formKey.currentState!.validate()) {
      SignUpViewInhterited.of(context)?.nextPage();
    }
  }
}
