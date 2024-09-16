import 'package:flutter/material.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../inherited/audio_processor_inherited.dart';
import '../../util/sizer_util.dart';
import '../../widget/app_dialog.dart';
import '../../widget/app_elevated_button.dart';
import '../../widget/app_text.dart';
import '../../widget/video_loader_shimmer.dart';
import 'enhancer_video_player.dart';

class OutputVideoDialog extends StatelessWidget {
  const OutputVideoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AudioProcessorInherited.of(context);

    return AppDialog(
      innerPadding: SizerUtil.padHorizontal(8) + SizerUtil.padVertical(12),
      radius: SizerUtil.borderRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: SizerUtil.scaleHeight(32),
          ),
          SizedBox(
            height: SizerUtil.videoHeight,
            child: _buildOutputVideo(state),
          ),
          SizedBox(
            height: SizerUtil.scaleHeight(32),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppElevatedButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const AppText(
                StringConstant.backText,
                color: ColorConstant.textWhite,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOutputVideo(VideoPlayerViewProviderState state) {
    return AnimatedSwitcher(
      duration: SizerUtil.durationSwitcher,
      child: switch (state.effectOperationEnum) {
        EffectOperationEnum.initial => const SizedBox(),
        EffectOperationEnum.loading => const VideoLoaderShimmer(),
        EffectOperationEnum.error => const AppText(StringConstant.generalErrorText),
        EffectOperationEnum.loaded => EnhancerVideoPlayer(
            label: StringConstant.videoOutputLabel,
            input: state.effectedVideoOutputPath,
          ),
      },
    );
  }
}
