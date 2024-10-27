import 'package:donna_clone/app/enum/app_view_pages.dart';
import 'package:donna_clone/features/home/pages/app_view.dart';
import 'package:flutter/material.dart';

mixin AppViewManager on State<AppView> {
  late final PageController pageController;
  AppViewPages activePage = AppViewPages.create;

  void updateNavBarPage(int index) {
    setState(() {
      activePage = AppViewPages.values[index];
    });
  }

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
}

class AppViewInherited extends InheritedWidget {
  const AppViewInherited({
    super.key,
    this.activePage = AppViewPages.create,
    required this.pageController,
    required super.child,
  });

  final AppViewPages activePage;
  final PageController pageController;

  Future<void> toNavBarPage(AppViewPages destination) async {
    int step = 0;
    bool isNext = true;

    if (destination.index > activePage.index) {
      step = destination.index - activePage.index;
      isNext = true;
    } else if (destination.index < activePage.index) {
      step = activePage.index - destination.index;
      isNext = false;
    } else {
      step = 0;
    }

    do {
      if (isNext) {
        await pageController.nextPage(duration: Durations.short1, curve: Curves.linear);
      } else {
        await pageController.previousPage(duration: Durations.short1, curve: Curves.linear);
      }
      step = step - 1;
    } while (step > 0);
  }

  static AppViewInherited of(BuildContext context) {
    final inhterited = context.dependOnInheritedWidgetOfExactType<AppViewInherited>();
    if (inhterited == null) {
      throw Exception("Can not find AppViewInherited");
    }
    return inhterited;
  }

  @override
  bool updateShouldNotify(AppViewInherited oldWidget) {
    return true;
  }
}
