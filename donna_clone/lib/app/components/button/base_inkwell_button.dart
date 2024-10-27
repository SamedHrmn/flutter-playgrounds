import 'package:flutter/material.dart';

class BaseInkwellButton extends StatelessWidget {
  const BaseInkwellButton({
    super.key,
    required this.color,
    required this.borderRadius,
    required this.onTap,
    required this.padding,
    required this.child,
  });

  final Color color;
  final BorderRadiusGeometry borderRadius;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius.resolve(TextDirection.ltr),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
