import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fragment_shader_sample/asset_image_helper.dart';
import 'package:fragment_shader_sample/fragment_shader_helper.dart';
import 'package:fragment_shader_sample/main.dart';

mixin ShaderBurnEffectController on State<ShaderBurnEffect> {
  late final FragmentShaderHelper fragmentShaderHelper;
  final imageAssetPath = "assets/images/test.png";
  ui.Image? image;
  late Timer timer;
  double elapsedTime = 0;
  bool isPlaying = false;
  bool isCompleted = false;
  bool isRestored = false;

  @override
  void initState() {
    super.initState();

    fragmentShaderHelper = FragmentShaderHelper.instance();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;

      await fragmentShaderHelper.initShader();
      image = await AssetImageHelper.decodeAssetImageAsUiImage(context, imageAssetPath);

      if (image == null) return;

      final placeholderTexture = await AssetImageHelper.takeCanvasPicture(
        image!.width,
        image!.height,
        Theme.of(context).scaffoldBackgroundColor,
      );

      fragmentShaderHelper.setTextureSampler(image!, BurningShaderUniforms.sourceTexture);
      fragmentShaderHelper.setTextureSampler(placeholderTexture, BurningShaderUniforms.targetTexture);
      fragmentShaderHelper.setTimer(elapsedTime);

      setState(() {});
    });
  }

  @override
  void dispose() {
    fragmentShaderHelper.dispose();
    timer.cancel();
    super.dispose();
  }

  void startAnimation() {
    if (isPlaying) return;

    setState(() {
      isCompleted = false;
      isPlaying = true;
      elapsedTime = 0;
      isRestored = false;
    });

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        elapsedTime += 0.016;
        fragmentShaderHelper.setTimer(elapsedTime);
      });

      if (elapsedTime >= 3) {
        stopAnimation();
      }
    });
  }

  void stopAnimation() {
    timer.cancel();
    setState(() {
      isPlaying = false;
      isCompleted = true;
    });
  }

  void restoreShader() {
    setState(() {
      isRestored = true;
    });

    fragmentShaderHelper.setTimer(0);
  }
}
