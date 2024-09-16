import 'package:flutter/material.dart';

class AppDropdownButton<T> extends StatelessWidget {
  const AppDropdownButton({super.key, required this.value, required this.items, this.onChanged, this.borderRadius});

  final T value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      items: items,
      onChanged: onChanged,
      value: value,
      borderRadius: borderRadius,
    );
  }
}
