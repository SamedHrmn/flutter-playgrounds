import 'package:flutter/material.dart';

class AuthOnboardViewInherited extends InheritedWidget {
  const AuthOnboardViewInherited({required this.pageController, required this.child, super.key}) : super(child: child);

  final Widget child;
  final PageController pageController;

  static AuthOnboardViewInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthOnboardViewInherited>();
  }

  @override
  bool updateShouldNotify(AuthOnboardViewInherited oldWidget) {
    return false;
  }
}
