import 'package:donna_clone/app/components/base_asset_image.dart';
import 'package:flutter/material.dart';

class AppAssetImage extends StatelessWidget {
  const AppAssetImage({
    super.key,
    required this.path,
    this.radius = 12,
  });

  final String? path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BaseAssetImage(path: path),
    );
  }
}
