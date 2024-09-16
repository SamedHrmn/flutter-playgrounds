import 'package:flutter/material.dart';

class AppFabButton extends StatelessWidget {
  const AppFabButton({super.key, required this.onPressed, required this.child});

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(onPressed: onPressed, label: child);
  }
}
