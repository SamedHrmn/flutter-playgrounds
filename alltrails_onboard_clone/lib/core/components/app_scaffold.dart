import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.body,
    this.scaffoldKey,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  final Widget? body;
  final Key? scaffoldKey;
  final bool canPop;

  final void Function(bool, dynamic)? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: ColorConstants.background,
        key: scaffoldKey,
        body: body,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
