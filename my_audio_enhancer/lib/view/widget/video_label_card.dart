import 'package:flutter/material.dart';
import '../../constant/color_constant.dart';
import '../../util/sizer_util.dart';
import '../../widget/app_text.dart';

class VideoLabelCard extends StatelessWidget {
  const VideoLabelCard({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: SizerUtil.borderRadius),
      child: Padding(
        padding: SizerUtil.padHorizontal(8) + SizerUtil.padVertical(4),
        child: AppText(
          label!,
          color: ColorConstant.textWhite,
        ),
      ),
    );
  }
}
