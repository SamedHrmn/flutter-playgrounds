import 'package:donna_clone/app/components/button/base_inkwell_button.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:flutter/material.dart';

class AppInkwellButton extends StatelessWidget {
  const AppInkwellButton({
    super.key,
    required this.onTap,
    this.padding = EdgeInsets.zero,
    this.borderRadius,
    required this.color,
    required this.child,
  });

  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return BaseInkwellButton(
      color: color,
      borderRadius: borderRadius ?? AppSizer.borderRadius,
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }
}
