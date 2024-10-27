import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.scaffoldState,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    required this.child,
  });

  final GlobalKey<ScaffoldState>? scaffoldState;
  final Color? backgroundColor;
  final Widget child;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: scaffoldState,
      body: child,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
