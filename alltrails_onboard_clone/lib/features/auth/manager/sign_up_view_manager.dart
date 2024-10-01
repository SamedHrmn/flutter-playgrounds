import 'package:alltrails_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_view.dart';
import 'package:alltrails_onboard_clone/locator.dart';
import 'package:flutter/material.dart';

mixin SignUpViewManager on State<SignUpView> {
  int pageIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void updatePageIndex(int i) {
    setState(() {
      pageIndex = i;
    });
  }

  void onBack() {
    if (pageIndex == 0) {
      getIt<AppNavigationManager>().goBack(context);
    } else {
      pageController.previousPage(duration: Durations.short2, curve: Curves.linear);
    }
  }
}
