import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import '../enum/effect_types.dart';
import '../model/audio_effect_settings.dart';

class AudioProcessor {
  /// Applies audio effects to an input audio file and saves the result to a new file.
  ///
  /// [inputPath] is the file path of the input audio.
  /// [outputPath] is the file path where the processed audio should be saved.
  /// [settings] contains the effect settings that define how each audio effect should be applied.
  ///
  /// This method iterates over the provided [AudioEffectSettings] and constructs a list of FFmpeg
  /// audio filter commands based on the user's selections. The effects are combined and applied using FFmpeg.
  ///
  /// Returns `true` if the process succeeds, or `false` if it fails.
  static Future<bool> applyAudioEffects({
    required String inputPath,
    required String outputPath,
    required AudioEffectSettings settings,
  }) async {
    List<String> effects = [];

    for (var entry in settings.settings.entries) {
      final type = entry.key;

      final value = settings.getEffectValue(type);

      switch (type) {
        case EffectTypes.noiseReduction:
          effects.add('afftdn=nf=$value');

          break;
        case EffectTypes.echoDelay:
          effects.add('aecho=0.8:0.88:$value:${settings.getEffectValue(EffectTypes.echoDecay)}');

          break;
        case EffectTypes.echoDecay:
          break;
        case EffectTypes.bassGain:
          effects.add('bass=g=$value');

          break;
        case EffectTypes.trebleGain:
          effects.add('treble=g=$value');

          break;
        case EffectTypes.volume:
          effects.add('volume=$value');

          break;
        case EffectTypes.reverb:
          effects.add('areverb=reverberance=$value');

          break;
        case EffectTypes.compressorThreshold:
          effects.add('acompressor=threshold=$value:ratio=${settings.getEffectValue(EffectTypes.compressorRatio)}:attack=200:release=1000');

          break;
        case EffectTypes.compressorRatio:
          break;
        case EffectTypes.chorusInGain:
          effects.add('chorus=in_gain=$value:out_gain=${settings.getEffectValue(EffectTypes.chorusOutGain)}:delays=50:decays=0.4:speeds=0.25:depths=2');

          break;
        case EffectTypes.chorusOutGain:
          break;
        case EffectTypes.equalizerGain:
          effects.add('equalizer=f=1000:t=q:w=1:g=$value');

          break;
        default:
          break;
      }
    }

    String combinedEffects = effects.join(',');

    String command = '-i $inputPath -af "$combinedEffects" -c:v copy $outputPath';

    try {
      final result = await FFmpegKit.execute(command);
      final st = await result.getState();
      return st != SessionState.failed;
    } catch (e) {
      return false;
    }
  }
}
