import 'package:flutter/material.dart';
import 'package:my_audio_waveform_example/control_panel_view.dart';
import 'package:my_audio_waveform_example/manager/audio_recorder_screen_manager.dart';
import 'package:my_audio_waveform_example/constants/string_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AudioRecorderScreen(),
    );
  }
}

class AudioRecorderScreen extends StatefulWidget {
  const AudioRecorderScreen({super.key});

  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> with AudioRecorderScreenManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StringConstants.appTitle),
        centerTitle: true,
      ),
      body: !hasMicrophonePermission
          ? const Center(
              child: Text(StringConstants.allowMicrophoneSettings),
            )
          : const ControlPanelView(),
    );
  }
}
