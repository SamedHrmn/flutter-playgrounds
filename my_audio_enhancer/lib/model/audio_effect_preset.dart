import 'audio_effect_settings.dart';

import '../enum/effect_types.dart';

class AudioEffectPreset {
  final String name;
  final AudioEffectSettings settings;

  AudioEffectPreset({required this.name, required this.settings});

  static List<AudioEffectPreset> effectPresets = [
    AudioEffectPreset(
      name: 'Basic Effect',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -25, minValue: -50, maxValue: 0),
        EffectTypes.echoDelay: EffectSetting(defaultValue: 60, minValue: 0, maxValue: 200),
        EffectTypes.echoDecay: EffectSetting(defaultValue: 0.4, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2, minValue: 0, maxValue: 5),
      }),
    ),
    AudioEffectPreset(
      name: 'High Bass',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -30, minValue: -50, maxValue: 0),
        EffectTypes.echoDelay: EffectSetting(defaultValue: 40, minValue: 0, maxValue: 200),
        EffectTypes.echoDecay: EffectSetting(defaultValue: 0.6, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 10, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 3, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 1.5, minValue: 0, maxValue: 5),
      }),
    ),
    AudioEffectPreset(
      name: 'Vocal Boost',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -20, minValue: -50, maxValue: 0),
        EffectTypes.echoDelay: EffectSetting(defaultValue: 80, minValue: 0, maxValue: 200),
        EffectTypes.echoDecay: EffectSetting(defaultValue: 0.3, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 4, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 8, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 3, minValue: 0, maxValue: 5),
        EffectTypes.reverb: EffectSetting(defaultValue: 50, minValue: 0, maxValue: 100),
      }),
    ),
    AudioEffectPreset(
      name: 'Concert Hall',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -15, minValue: -50, maxValue: 0),
        EffectTypes.echoDelay: EffectSetting(defaultValue: 120, minValue: 0, maxValue: 200),
        EffectTypes.echoDecay: EffectSetting(defaultValue: 0.7, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 6, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 6, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2.5, minValue: 0, maxValue: 5),
        EffectTypes.reverb: EffectSetting(defaultValue: 80, minValue: 0, maxValue: 100),
      }),
    ),
    AudioEffectPreset(
      name: 'Soft Compression',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -18, minValue: -50, maxValue: 0),
        EffectTypes.compressorThreshold: EffectSetting(defaultValue: -30, minValue: -50, maxValue: 0),
        EffectTypes.compressorRatio: EffectSetting(defaultValue: 4, minValue: 1, maxValue: 20),
        EffectTypes.bassGain: EffectSetting(defaultValue: 3, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 4, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2, minValue: 0, maxValue: 5),
      }),
    ),
    AudioEffectPreset(
      name: 'Dynamic Chorus',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -22, minValue: -50, maxValue: 0),
        EffectTypes.chorusInGain: EffectSetting(defaultValue: 0.5, minValue: 0, maxValue: 1),
        EffectTypes.chorusOutGain: EffectSetting(defaultValue: 0.3, minValue: 0, maxValue: 1),
        EffectTypes.bassGain: EffectSetting(defaultValue: 4, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2, minValue: 0, maxValue: 5),
      }),
    ),
    AudioEffectPreset(
      name: 'Balanced Equalizer',
      settings: AudioEffectSettings(settings: {
        EffectTypes.noiseReduction: EffectSetting(defaultValue: -20, minValue: -50, maxValue: 0),
        EffectTypes.equalizerGain: EffectSetting(defaultValue: 5, minValue: -10, maxValue: 10),
        EffectTypes.bassGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.trebleGain: EffectSetting(defaultValue: 5, minValue: 0, maxValue: 10),
        EffectTypes.volume: EffectSetting(defaultValue: 2.5, minValue: 0, maxValue: 5),
      }),
    ),
  ];
}
