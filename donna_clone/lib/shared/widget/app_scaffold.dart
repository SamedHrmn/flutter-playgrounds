import 'package:donna_clone/app/components/base_scaffold.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.canPop = false,
    this.onPopInvokedWithResult,
    required this.child,
  });

  final Widget child;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: BaseScaffold(
        resizeToAvoidBottomInset: false,
        child: child,
      ),
    );
  }
}
