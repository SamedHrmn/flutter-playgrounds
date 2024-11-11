import 'package:flutter/material.dart';
import 'package:my_audio_waveform/my_audio_waveform.dart';
import 'package:my_audio_waveform_example/constants/color_constants.dart';

class PlaybackSeekbar extends StatelessWidget {
  const PlaybackSeekbar({super.key, this.playbackData});

  final PlaybackData? playbackData;

  @override
  Widget build(BuildContext context) {
    if (playbackData == null) return const SizedBox();

    final currentPosition = ((playbackData!.currentPosition ?? 0) / 1000).truncate();
    final duration = ((playbackData!.duration ?? 0) / 1000).truncate();

    return Column(
      children: [
        Text(
          "Position: $currentPosition / $duration",
        ),
        Slider(
          value: currentPosition.toDouble().clamp(0.0, duration.toDouble()),
          thumbColor: ColorConstants.primary,
          activeColor: ColorConstants.secondary,
          max: duration.toDouble(),
          onChanged: (_) {},
        ),
      ],
    );
  }
}
