import 'package:alltrails_onboard_clone/core/enum/route_enum.dart';
import 'package:alltrails_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_page_step3.dart';
import 'package:alltrails_onboard_clone/locator.dart';
import 'package:flutter/material.dart';

mixin SignUpPageStep3Manager on State<SignUpPageStep3> {
  final formKey = GlobalKey<FormState>();

  Future<void> onNext() async {
    if (formKey.currentState!.validate()) {
      getIt<AppNavigationManager>().navigateTo(RouteEnum.paywallViewPath);
    }
  }
}
