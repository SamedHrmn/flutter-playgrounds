import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
