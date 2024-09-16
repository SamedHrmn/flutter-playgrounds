import 'package:flutter/material.dart';
import '../constant/color_constant.dart';
import '../constant/string_constant.dart';
import 'app_text.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.floatingButton,
    required this.child,
  });

  final Widget child;
  final Widget? floatingButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.scaffoldBackground,
      floatingActionButton: floatingButton,
      appBar: AppBar(
        title: const AppText(
          StringConstant.appBarTitle,
          fontSize: 24,
        ),
      ),
      body: SafeArea(child: child),
    );
  }
}
