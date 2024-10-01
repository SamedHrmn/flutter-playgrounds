import 'package:flutter/material.dart';

class SignUpViewInhterited extends InheritedWidget {
  const SignUpViewInhterited({super.key, required this.pageController, required this.child}) : super(child: child);

  final Widget child;
  final PageController pageController;

  static SignUpViewInhterited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SignUpViewInhterited>();
  }

  void nextPage() {
    pageController.nextPage(duration: Durations.short2, curve: Curves.linear);
  }

  @override
  bool updateShouldNotify(SignUpViewInhterited oldWidget) {
    return true;
  }
}
