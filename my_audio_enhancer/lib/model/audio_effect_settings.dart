import 'package:flutter/foundation.dart';

import '../enum/effect_types.dart';
import 'audio_effect_preset.dart';

class AudioEffectSettings {
  final Map<EffectTypes, EffectSetting> settings;

  Map<EffectTypes, double> values;

  AudioEffectSettings({required this.settings})
      : values = {
          for (var entry in settings.entries) entry.key: entry.value.defaultValue,
        };

  factory AudioEffectSettings.defaultSettings() {
    return AudioEffectSettings(
      settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -25, minValue: -50, maxValue: 0),
        EffectTypes.echoDelay: EffectSetting(defaultValue: 60, minValue: 0, maxValue: 200),
        EffectTypes.echoDecay: EffectSetting(defaultValue: 0.4, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2, minValue: 0, maxValue: 5),
      },
    );
  }

  double getEffectValue(EffectTypes type) {
    return values[type] ?? settings[type]?.defaultValue ?? 0.0;
  }

  AudioEffectPreset toPreset(List<AudioEffectPreset> effectPresets) {
    for (var preset in effectPresets) {
      if (_areSettingsEqual(preset.settings, this)) {
        return preset;
      }
    }
    return AudioEffectPreset(name: "Custom", settings: this);
  }

  bool _areSettingsEqual(AudioEffectSettings presetSettings, AudioEffectSettings currentSettings) {
    if (presetSettings.settings.keys.length != currentSettings.settings.keys.length) {
      return false;
    }

    for (var key in presetSettings.settings.keys) {
      final presetValue = presetSettings.getEffectValue(key);
      final currentValue = currentSettings.getEffectValue(key);
      if (presetValue != currentValue) {
        return false;
      }
    }

    return true;
  }

  @override
  bool operator ==(covariant AudioEffectSettings other) {
    if (identical(this, other)) return true;

    return mapEquals(other.settings, settings) && mapEquals(other.values, values);
  }

  @override
  int get hashCode => settings.hashCode ^ values.hashCode;
}

class EffectSetting {
  final double defaultValue;
  final double minValue;
  final double maxValue;

  EffectSetting({
    required this.defaultValue,
    required this.minValue,
    required this.maxValue,
  });
}
