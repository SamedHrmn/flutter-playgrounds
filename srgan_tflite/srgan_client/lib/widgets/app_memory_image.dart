import 'package:flutter/material.dart';
import 'package:srgan_client/constants/size_constants.dart';

import '../utils/image_util.dart';

class AppMemoryImage extends StatelessWidget {
  const AppMemoryImage({super.key, required this.base64Str});

  final String base64Str;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: SizeConstants.borderRadiusGeneral(),
      child: Image.memory(
        width: double.maxFinite,
        alignment: Alignment.bottomCenter,
        ImageUtil.decodeBase64(base64Str),
        fit: BoxFit.cover,
      ),
    );
  }
}
