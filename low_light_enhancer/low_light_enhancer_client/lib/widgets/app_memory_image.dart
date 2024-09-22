import 'package:flutter/material.dart';
import 'package:low_light_enhancer_client/constants/size_constants.dart';

import '../utils/image_util.dart';

class AppMemoryImage extends StatelessWidget {
  const AppMemoryImage({super.key, required this.base64Str});

  final String base64Str;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: SizeConstants.borderRadiusGeneral(),
      child: Image.memory(
        ImageUtil.decodeBase64(base64Str),
        fit: BoxFit.cover,
      ),
    );
  }
}
