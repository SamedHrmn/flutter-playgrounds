import 'package:flutter/material.dart';
import 'package:my_audio_waveform_example/main.dart';
import 'package:my_audio_waveform_example/util/permission_util.dart';

mixin AudioRecorderScreenManager on State<AudioRecorderScreen> {
  bool hasMicrophonePermission = false;

  Future<void> _requestMicrophonePermission() async {
    if (await PermissionUtil.hasMicrophonePermission()) {
      setState(() => hasMicrophonePermission = true);
    } else {
      await PermissionUtil.askMicrophonePermission();
      final isGranted = await PermissionUtil.hasMicrophonePermission();
      setState(() => hasMicrophonePermission = isGranted);
    }
  }

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }
}
