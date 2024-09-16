import 'package:flutter/material.dart';
import '../constant/color_constant.dart';
import '../util/sizer_util.dart';
import 'app_shimmer_loader.dart';

class VideoLoaderShimmer extends StatelessWidget {
  const VideoLoaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmerLoader(
      child: ClipRRect(
        borderRadius: SizerUtil.borderRadius,
        child: SizedBox(
          height: SizerUtil.videoHeight,
          width: double.infinity,
          child: const ColoredBox(color: ColorConstant.scaffoldBackground),
        ),
      ),
    );
  }
}
