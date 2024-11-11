import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'my_audio_waveform_platform_interface.dart';

class MethodChannelMyAudioWaveform extends MyAudioWaveformPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('my_audio_waveform/method');

  @override
  Future<void> pauseRecording() async {
    await methodChannel.invokeMethod("pauseRecording");
  }

  @override
  Future<void> resumeRecording() async {
    await methodChannel.invokeMethod("resumeRecording");
  }

  @override
  Future<void> startRecording() async {
    await methodChannel.invokeMethod("startRecording");
  }

  @override
  Future<void> stopRecording() async {
    await methodChannel.invokeMethod("stopRecording");
  }

  @override
  Future<void> startPlayback() async {
    await methodChannel.invokeMethod("startPlayback");
  }

  @override
  Future<void> stopPlayback() async {
    await methodChannel.invokeMethod("stopPlayback");
  }
}
