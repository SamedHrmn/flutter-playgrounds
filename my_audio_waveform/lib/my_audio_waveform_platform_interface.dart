import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'my_audio_waveform_method_channel.dart';

abstract class MyAudioWaveformPlatform extends PlatformInterface {
  MyAudioWaveformPlatform() : super(token: _token);

  static final Object _token = Object();

  static MyAudioWaveformPlatform _instance = MethodChannelMyAudioWaveform();

  static MyAudioWaveformPlatform get instance => _instance;

  static set instance(MyAudioWaveformPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startRecording();
  Future<void> stopRecording();
  Future<void> pauseRecording();
  Future<void> resumeRecording();
  Future<void> startPlayback();
  Future<void> stopPlayback();
}
