import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/features/auth/inherited/auth_onboard_view_inherited.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/email_tab_body.dart';

mixin EmailTabBodyManager on State<EmailTabBody> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  bool checkboxValue = false;

  void updateEmail(String v) {
    setState(() {
      email = v;
    });
  }

  void updateCheckbox(bool? v) {
    setState(() {
      checkboxValue = v!;
    });
  }

  bool get buttonIsActive => checkboxValue && email.isNotEmpty;

  void goNextPage(BuildContext context) {
    AuthOnboardViewInherited.of(context)!.pageController.nextPage(duration: Durations.short1, curve: Curves.linear);
  }

  Future<void> onPressedNext() async {
    final ctx = context;

    if (formKey.currentState!.validate()) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return const SliderCaptchaDialog();
        },
      );

      if (!ctx.mounted) return;
      goNextPage(ctx);
    }
  }
}
