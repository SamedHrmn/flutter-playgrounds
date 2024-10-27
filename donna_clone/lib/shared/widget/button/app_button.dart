import 'package:donna_clone/app/components/button/base_button.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.isCircular = false,
    this.radius = 8,
    this.onPressed,
    this.buttonColor,
    this.gradient,
    this.padding = EdgeInsets.zero,
    this.child,
  });

  final Widget? child;
  final bool isCircular;
  final Future<void> Function()? onPressed;
  final Color? buttonColor;
  final EdgeInsets padding;
  final double radius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      buttonColor: buttonColor,
      padding: EdgeInsets.zero,
      isCircular: isCircular,
      onPressed: onPressed,
      radius: radius,
      child: AnimatedContainer(
        duration: Durations.medium3,
        padding: padding,
        decoration: BoxDecoration(
          gradient: buttonColor == null ? gradient : null,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: !isCircular ? BorderRadius.circular(radius) : null,
        ),
        child: child,
      ),
    );
  }
}
