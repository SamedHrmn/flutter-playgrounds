import 'package:flutter/material.dart';
import '../constant/string_constant.dart';
import '../inherited/audio_processor_inherited.dart';
import '../enum/effect_types.dart';
import '../util/file_util.dart';
import '../util/permission_util.dart';
import '../util/sizer_util.dart';
import 'widget/effect_slider.dart';
import 'widget/preset_dropdown_button.dart';
import '../widget/app_elevated_button.dart';
import '../widget/app_fab_button.dart';
import '../widget/app_scaffold.dart';
import '../widget/app_text.dart';
import 'widget/enhancer_video_player.dart';
import '../widget/video_loader_shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        PermissionUtil.requestVideoPermission(),
        FileUtil.clearTemporaryFiles(),
      ]);

      if (await PermissionUtil.checkVideoPermissionIsGranted) {
        if (mounted) {
          await AudioProcessorInherited.of(context).pickAndLoadInputVideo();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingButton: const _FabButtonSection(),
      child: SingleChildScrollView(
        child: Padding(
          padding: SizerUtil.padHorizontal(24),
          child: Column(
            children: [
              _buildOriginalVideo(),
              _buildEffectSelector(context),
              _buildEffectControlPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOriginalVideo() {
    final state = AudioProcessorInherited.of(context);

    return AnimatedSwitcher(
      duration: SizerUtil.durationSwitcher,
      child: state.originalVideoOutputPath != null
          ? AnimatedSize(
              duration: Durations.medium1,
              child: SizedBox(
                height: SizerUtil.videoHeight,
                child: EnhancerVideoPlayer(
                  input: state.originalVideoOutputPath,
                ),
              ),
            )
          : const VideoLoaderShimmer(),
    );
  }

  Widget _buildEffectSelector(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: SizerUtil.padAll(16),
          child: const PresetDropdownButton(),
        ),
        const Spacer(),
        AppElevatedButton(
          onPressed: () {
            AudioProcessorInherited.of(context).resetValues();
          },
          child: const AppText(StringConstant.resetButtonText),
        ),
      ],
    );
  }

  Widget _buildEffectControlPanel(BuildContext context) {
    final state = AudioProcessorInherited.of(context);

    return Column(
      children: EffectTypes.values.map((type) {
        final effectSetting = state.effectSettings.settings[type];
        if (effectSetting == null) {
          return const SizedBox.shrink();
        }
        return EffectSlider(
            type: type,
            value: state.effectSettings.values[type]!,
            onChanged: (value) {
              AudioProcessorInherited.of(context).updateEffectValue(type, value);
            });
      }).toList(),
    );
  }
}

class _FabButtonSection extends StatelessWidget {
  const _FabButtonSection();

  @override
  Widget build(BuildContext context) {
    final state = AudioProcessorInherited.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppFabButton(
          onPressed: () {
            AudioProcessorInherited.of(context).applyEffects();

            if (!context.mounted) return;
            AudioProcessorInherited.of(context).showOutputVideoDialog(context);
          },
          child: const AppText(StringConstant.applyEffectButtonText),
        ),
        if (state.originalVideoOutputPath != null) ...{
          SizedBox(
            height: SizerUtil.scaleHeight(32),
          ),
          AppFabButton(
            onPressed: () async {
              await AudioProcessorInherited.of(context).pickAndLoadInputVideo();
            },
            child: const AppText(StringConstant.pickMediaButtonText),
          ),
        },
      ],
    );
  }
}
