import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_audio_waveform_example/constants/asset_constants.dart';
import 'package:my_audio_waveform_example/constants/string_constants.dart';
import 'package:my_audio_waveform_example/manager/control_panel_manager.dart';
import 'package:my_audio_waveform_example/widget/control_button.dart';
import 'package:my_audio_waveform_example/widget/playback_seekbar.dart';
import 'package:my_audio_waveform_example/widget/waveform_painter.dart';

class ControlPanelView extends StatefulWidget {
  const ControlPanelView({super.key});

  @override
  State<ControlPanelView> createState() => _ControlPanelViewState();
}

class _ControlPanelViewState extends State<ControlPanelView> with ControlPanelManager {
  @override
  Widget build(BuildContext context) {
    final sHeight = MediaQuery.sizeOf(context).height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        if (audioState == AudioState.idle) ...[
          ControlButton(
            text: StringConstants.startRecording,
            onPressed: startRecording,
          ),
          if (waveformData != null) ...{
            const SizedBox(height: 24),
            ControlButton(
              onPressed: startPlayback,
              text: StringConstants.startPlayback,
            ),
          }
        ],
        if (audioState == AudioState.recording)
          ControlButton(
            onPressed: stopRecording,
            text: StringConstants.stopRecording,
          ),
        if (audioState == AudioState.playback)
          ControlButton(
            onPressed: stopPlayback,
            text: StringConstants.stopPlayback,
          ),
        const SizedBox(height: 20),
        if (audioState == AudioState.recording) ...{
          if (waveformData != null) ...{
            Lottie.asset(
              AssetConstants.lottieRecording,
              animate: true,
              addRepaintBoundary: true,
              height: sHeight * 0.25,
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: WaveformPainter(waveformData!, style: WaveformStyle.line),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: CustomPaint(
                          painter: WaveformPainter(waveformData!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          } else ...{
            const Center(
              child: Text(StringConstants.noWaveformData),
            )
          },
        },
        if (audioState == AudioState.playback) ...{
          PlaybackSeekbar(
            playbackData: playbackData,
          ),
        },
        const Spacer(),
      ],
    );
  }
}
