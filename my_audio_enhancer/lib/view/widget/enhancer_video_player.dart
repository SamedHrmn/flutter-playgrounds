import 'dart:io';
import 'package:flutter/material.dart';
import '../../constant/color_constant.dart';
import '../../constant/string_constant.dart';
import '../../util/sizer_util.dart';
import 'video_label_card.dart';
import '../../widget/app_text.dart';
import 'package:video_player/video_player.dart';

class EnhancerVideoPlayer extends StatefulWidget {
  const EnhancerVideoPlayer({super.key, this.label, required this.input});
  final String? label;
  final String? input;

  @override
  State<EnhancerVideoPlayer> createState() => _EnhancerVideoPlayerState();
}

class _EnhancerVideoPlayerState extends State<EnhancerVideoPlayer> {
  VideoPlayerController? controller;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool showOverlay = false;

  @override
  void initState() {
    super.initState();
    if (widget.input == null) return;

    _initializeController();
  }

  void _initializeController() {
    controller = VideoPlayerController.file(File(widget.input!))
      ..initialize().then((_) {
        controller!.addListener(() {
          setState(() {
            position = controller!.value.position;
            isPlaying = controller!.value.isPlaying;
          });
        });
        setState(() {});
      });
  }

  @override
  void dispose() {
    if (mounted) {
      controller?.dispose();
    }
    super.dispose();
  }

  Future<void> pause() async {
    await controller?.pause();
  }

  Future<void> play() async {
    await controller?.play();
  }

  Future<void> _onSeekBarChanged(double value) async {
    final position = Duration(seconds: value.toInt());
    await controller?.seekTo(position);
  }

  Future<void> _onVideoTap() async {
    if (controller?.value.isInitialized == false) return;

    if (controller?.value.isPlaying == true) {
      await pause();
    } else if (controller?.value.isPlaying == false) {
      await play();
    }

    setState(() {
      showOverlay = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          showOverlay = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const thumbColor = Colors.blueAccent;
    final inactiveTrackColor = Colors.white.withOpacity(0.5);

    if (widget.input == null) {
      return const AppText(StringConstant.videoInputErrorText);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoLabelCard(label: widget.label),
        controller?.value.isInitialized == true
            ? Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await _onVideoTap();
                  },
                  child: AspectRatio(
                    aspectRatio: controller?.value.aspectRatio ?? 1,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        _videoPlayer(),
                        Positioned.fill(
                          child: _videoPlayPauseFeedbackAnimation(),
                        ),
                        Positioned(
                          bottom: 0,
                          left: SizerUtil.scaleWidth(16),
                          right: SizerUtil.scaleWidth(16),
                          child: _videoProgressBar(context, thumbColor, inactiveTrackColor),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Expanded(
                child: SizedBox(
                  height: SizerUtil.videoHeight,
                ),
              ),
      ],
    );
  }

  Row _videoProgressBar(BuildContext context, MaterialAccentColor thumbColor, Color inactiveTrackColor) {
    return Row(
      children: [
        AppText(
          position.toString().split('.').first,
          color: ColorConstant.textWhite,
        ),
        SizedBox(width: SizerUtil.scaleWidth(16)),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbColor: thumbColor,
              activeTrackColor: thumbColor,
              inactiveTrackColor: inactiveTrackColor,
              overlayColor: thumbColor,
            ),
            child: Slider(
              min: 0,
              max: controller?.value.duration.inSeconds.toDouble() ?? 1,
              value: position.inSeconds.toDouble(),
              onChanged: _onSeekBarChanged,
            ),
          ),
        ),
      ],
    );
  }

  AnimatedOpacity _videoPlayPauseFeedbackAnimation() {
    return AnimatedOpacity(
      opacity: showOverlay ? 1.0 : 0.0,
      duration: Durations.medium1,
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: SizerUtil.scaleHeight(64),
        color: Colors.white,
      ),
    );
  }

  ClipRRect _videoPlayer() {
    return ClipRRect(
      borderRadius: SizerUtil.borderRadius,
      child: controller != null ? VideoPlayer(controller!) : const SizedBox.shrink(),
    );
  }
}
