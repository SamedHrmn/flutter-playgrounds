import 'package:flutter/material.dart';
import '../../inherited/audio_processor_inherited.dart';
import '../../util/sizer_util.dart';
import '../../widget/app_text.dart';

import '../../enum/effect_types.dart';

class EffectSlider extends StatelessWidget {
  const EffectSlider({super.key, required this.type, required this.value, required this.onChanged});

  final EffectTypes type;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final state = AudioProcessorInherited.of(context);
    final effectSetting = state.effectSettings.settings[type]!;
    final maxV = effectSetting.maxValue;
    final minV = effectSetting.minValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(type.name),
        SliderTheme(
          data: SliderThemeData(overlayShape: SliderComponentShape.noThumb),
          child: Padding(
            padding: SizerUtil.padVertical(16),
            child: Slider(
              value: value,
              min: minV,
              max: maxV,
              divisions: (maxV - minV).toInt(),
              label: value.toStringAsFixed(2),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
