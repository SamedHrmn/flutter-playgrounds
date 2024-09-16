import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({super.key, required this.child, this.insetPadding, this.innerPadding = EdgeInsets.zero, this.radius});

  final Widget child;
  final EdgeInsets? insetPadding;
  final EdgeInsets innerPadding;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: radius ?? BorderRadius.circular(4)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: innerPadding,
        child: SizedBox(
          width: double.maxFinite,
          child: child,
        ),
      ),
    );
  }
}
