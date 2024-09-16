import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({super.key, this.onPressed, required this.child, this.backgroundColor});

  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      child: child,
    );
  }
}
