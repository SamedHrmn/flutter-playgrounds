import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_audio_waveform/my_audio_waveform.dart';
import 'package:my_audio_waveform_example/control_panel_view.dart';

enum AudioState { idle, recording, playback }

mixin ControlPanelManager on State<ControlPanelView> {
  late StreamSubscription<List<double>?> _waveformSubscription;
  late StreamSubscription<PlaybackData?> _playbackDataSubscription;

  AudioState audioState = AudioState.idle;

  List<double>? waveformData;
  PlaybackData? playbackData;

  void updateAudioState(AudioState state) {
    setState(() {
      audioState = state;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await MyAudioWaveform.initialize();
    _waveformSubscription = MyAudioWaveform.waveformStream.listen((data) {
      setState(() => waveformData = data);
    });
    _playbackDataSubscription = MyAudioWaveform.playbackStream.listen((data) {
      setState(() => playbackData = data);
    });
  }

  Future<void> startRecording() async {
    updateAudioState(AudioState.recording);
    await MyAudioWaveform.startRecording();
  }

  Future<void> stopRecording() async {
    updateAudioState(AudioState.idle);
    await MyAudioWaveform.stopRecording();
  }

  Future<void> startPlayback() async {
    updateAudioState(AudioState.playback);
    await MyAudioWaveform.startPlayback();
  }

  Future<void> stopPlayback() async {
    updateAudioState(AudioState.idle);
    await MyAudioWaveform.stopPlayback();
  }

  @override
  void dispose() {
    _waveformSubscription.cancel();
    _playbackDataSubscription.cancel();

    super.dispose();
  }
}
