import 'package:flutter/material.dart';

class BaseAssetImage extends StatelessWidget {
  const BaseAssetImage({super.key, required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return const Placeholder();
    }

    return Image.asset(
      path!,
      fit: BoxFit.cover,
    );
  }
}
