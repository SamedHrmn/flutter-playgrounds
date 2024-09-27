import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_view.dart';
import 'package:tiktok_onboard_clone/locator.dart';

mixin AuthOnboardViewManager on State<AuthOnboardView> {
  late PageController pageController;
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onBackPageView() {
    if (pageController.page == 0) {
      getIt<AppNavigationManager>().goBack(context);
    } else {
      pageController.previousPage(duration: Durations.short1, curve: Curves.linear);
    }
  }

  void updatePageIndex(int i) {
    pageIndexNotifier.value = i;
  }
}
