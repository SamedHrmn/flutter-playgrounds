import 'dart:isolate';

import 'package:flutter/services.dart';

import 'my_audio_waveform_platform_interface.dart';

class MyAudioWaveform {
  static Isolate? _audioIsolate;
  static SendPort? _sendPort;
  static final ReceivePort _receivePort = ReceivePort();
  static const _waveformEventChannel = EventChannel('my_audio_waveform/event/waveform');
  static const _playbackEventChannel = EventChannel('my_audio_waveform/event/playback');

  static late Stream<List<double>?> waveformStream;
  static late Stream<PlaybackData?> playbackStream;

  static Future<void> initialize() async {
    if (_audioIsolate == null) {
      final rootIsolateToken = RootIsolateToken.instance!;
      _audioIsolate = await Isolate.spawn(_runAudioRecordingIsolate, [rootIsolateToken, _receivePort.sendPort]);

      _receivePort.listen((message) {
        if (message is SendPort) {
          _sendPort = message;
        }
      });
    }

    waveformStream = _waveformEventChannel.receiveBroadcastStream().map((event) {
      return List<double>.from(event);
    });

    playbackStream = _playbackEventChannel.receiveBroadcastStream().map((event) {
      return PlaybackData.fromMap(event as Map<Object?, Object?>?);
    });
  }

  static Future<void> startRecording() async {
    _sendPort?.send('startRecording');
  }

  static Future<void> pauseRecording() async {
    _sendPort?.send('pauseRecording');
  }

  static Future<void> resumeRecording() async {
    _sendPort?.send('resumeRecording');
  }

  static Future<void> stopRecording() async {
    _sendPort?.send('stopRecording');
  }

  static Future<void> startPlayback() async {
    _sendPort?.send('startPlayback');
  }

  static Future<void> stopPlayback() async {
    _sendPort?.send('stopPlayback');
  }

  static Future<void> clearRecording() async {
    _sendPort?.send('clearRecording');
  }

  static void _runAudioRecordingIsolate(List<dynamic> args) {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final mainSendPort = args[1] as SendPort;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen((message) async {
      switch (message) {
        case 'startRecording':
          await MyAudioWaveformPlatform.instance.startRecording();
          break;
        case 'pauseRecording':
          await MyAudioWaveformPlatform.instance.pauseRecording();
          break;
        case 'resumeRecording':
          await MyAudioWaveformPlatform.instance.resumeRecording();
          break;
        case 'stopRecording':
          await MyAudioWaveformPlatform.instance.stopRecording();
          break;
        case 'startPlayback':
          await MyAudioWaveformPlatform.instance.startPlayback();
          break;
        case 'stopPlayback':
          await MyAudioWaveformPlatform.instance.stopPlayback();
          break;
      }
    });
  }
}

class PlaybackData {
  final int? currentPosition;
  final int? duration;

  PlaybackData({
    required this.currentPosition,
    required this.duration,
  });

  factory PlaybackData.fromMap(Map<Object?, Object?>? json) {
    return PlaybackData(
      currentPosition: json?["currentPosition"] as int?,
      duration: json?["duration"] as int?,
    );
  }
}
