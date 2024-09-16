import 'package:flutter/material.dart';
import '../../inherited/audio_processor_inherited.dart';
import '../../model/audio_effect_preset.dart';
import '../../util/sizer_util.dart';
import '../../widget/app_dropdown_button.dart';
import '../../widget/app_text.dart';

class PresetDropdownButton extends StatelessWidget {
  const PresetDropdownButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AudioProcessorInherited.of(context);

    return AppDropdownButton<AudioEffectPreset>(
      value: state.selectedEffectPreset,
      borderRadius: SizerUtil.borderRadius,
      onChanged: (preset) {
        if (preset != null) {
          AudioProcessorInherited.of(context).updateSelectedPreset(preset);
          AudioProcessorInherited.of(context).updateEffectSettings(preset.settings);
        }
      },
      items: state.effectPresets.map((preset) {
        return DropdownMenuItem(
          value: preset,
          child: AppText(
            preset.name,
          ),
        );
      }).toList(),
    );
  }
}
