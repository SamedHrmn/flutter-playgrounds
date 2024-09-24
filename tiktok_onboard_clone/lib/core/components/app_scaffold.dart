import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.body,
    this.scaffoldKey,
    this.scaffoldBackgroundColor,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  final Widget? body;
  final Key? scaffoldKey;
  final bool canPop;
  final Color? scaffoldBackgroundColor;
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool, dynamic)? onPopInvokedWithResult;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        key: scaffoldKey,
        body: body,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
