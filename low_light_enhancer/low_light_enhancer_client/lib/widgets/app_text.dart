import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({super.key, required this.text, this.size, this.color});

  final String text;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.w600, color: color),
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
    );
  }
}
