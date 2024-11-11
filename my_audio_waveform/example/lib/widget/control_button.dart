import 'package:flutter/material.dart';
import 'package:my_audio_waveform_example/constants/color_constants.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: ColorConstants.primary,
          ),
        ),
      ),
    );
  }
}
