import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constant/color_constant.dart';
import '../constant/string_constant.dart';
import '../enum/effect_types.dart';
import '../model/audio_effect_settings.dart';
import '../util/audio_processor.dart';
import '../util/file_util.dart';
import '../widget/app_text.dart';
import '../model/audio_effect_preset.dart';
import '../view/widget/output_video_dialog.dart';

class AudioProcessorInherited extends InheritedWidget {
  const AudioProcessorInherited(
    this.videoPlayerViewProvider, {
    required this.widget,
    super.key,
  }) : super(child: widget);

  final Widget widget;
  final VideoPlayerViewProviderState videoPlayerViewProvider;

  static VideoPlayerViewProviderState of(BuildContext context) {
    if (context.dependOnInheritedWidgetOfExactType<AudioProcessorInherited>() == null) {
      throw Exception("AudioProcessorInherited is null");
    }

    return context.dependOnInheritedWidgetOfExactType<AudioProcessorInherited>()!.videoPlayerViewProvider;
  }

  @override
  bool updateShouldNotify(AudioProcessorInherited oldWidget) {
    return true;
  }
}

enum EffectOperationEnum {
  initial,
  loading,
  loaded,
  error,
}

class VideoPlayerViewProvider extends StatefulWidget {
  const VideoPlayerViewProvider({super.key, required this.child});

  final Widget child;

  @override
  State<VideoPlayerViewProvider> createState() => VideoPlayerViewProviderState();
}

class VideoPlayerViewProviderState extends State<VideoPlayerViewProvider> {
  late AudioEffectPreset selectedEffectPreset;
  AudioEffectSettings effectSettings = AudioEffectSettings.defaultSettings();
  String? originalVideoOutputPath;
  String? effectedVideoOutputPath;

  EffectOperationEnum effectOperationEnum = EffectOperationEnum.initial;
  List<AudioEffectSettings> appliedPresets = [];
  List<AudioEffectPreset> effectPresets = AudioEffectPreset.effectPresets;

  final String _outputVideoName = 'effectedVideo.mp4';
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    selectedEffectPreset = effectPresets.first;
    effectSettings = selectedEffectPreset.settings;
  }

  void updateEffectValue(EffectTypes type, double value) {
    setState(() {
      final setting = effectSettings.settings[type];
      if (setting != null) {
        if (value >= setting.minValue && value <= setting.maxValue) {
          effectSettings.values[type] = value;
        } else {
          effectSettings.values[type] = value < setting.minValue ? setting.minValue : setting.maxValue;
        }
      }
    });
  }

  void resetValues() {
    setState(() {
      effectSettings = AudioEffectSettings.defaultSettings();
      selectedEffectPreset = effectPresets.first;
    });
  }

  void _clearOutput() {
    setState(() {
      effectedVideoOutputPath = null;
    });
  }

  void _updateAppliedEffects() {
    setState(() {
      log("Applied Preset : ----------> ${effectSettings.values.toString()}");
      final model = AudioEffectSettings(settings: effectSettings.settings);
      appliedPresets.add(model);
    });
  }

  Future<XFile?> _pickVideoFromGallery() async {
    return FileUtil.pickVideoFromGallery();
  }

  void showErrorSnackbar(String text) {
    if (context.mounted && scaffoldKey.currentState != null) {
      _clearOutput();
      scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: AppText(
            text,
            color: ColorConstant.textWhite,
          ),
        ),
      );
    }
  }

  Future<void> pickAndLoadInputVideo() async {
    final pickedVideo = await _pickVideoFromGallery();

    if (pickedVideo == null) {
      showErrorSnackbar(StringConstant.pickedMediaError);
      return;
    }

    var paths = await Future.wait([
      FileUtil.createFilePath(fileName: 'input.mp4'),
      FileUtil.createFilePath(fileName: _outputVideoName),
    ]);

    if (paths.length < 2) return;

    await FileUtil.loadAndWriteFile(xFile: pickedVideo, fileInputPath: paths[0]);

    setState(() {
      originalVideoOutputPath = paths[0];
      effectedVideoOutputPath = null;
    });
  }

  void updateSelectedPreset(AudioEffectPreset preset) {
    setState(() {
      selectedEffectPreset = preset;
    });
  }

  void updateEffectSettings(AudioEffectSettings settings) {
    setState(() {
      effectSettings = settings;
    });
  }

  void _updateEffectOperationState(EffectOperationEnum operationEnum) {
    setState(() {
      effectOperationEnum = operationEnum;
    });
  }

  void showOutputVideoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "barrier_label",
      pageBuilder: (context, animation, secondaryAnimation) {
        return const OutputVideoDialog();
      },
    ).then(
      (_) => _clearOutput(),
    );
  }

  Future<void> applyEffects() async {
    if (effectSettings.values.isEmpty) {
      _updateEffectOperationState(EffectOperationEnum.error);
      return;
    }

    _updateEffectOperationState(EffectOperationEnum.loading);

    await FileUtil.deleteFileByName(_outputVideoName);

    final effectedPath = await FileUtil.createFilePath(fileName: _outputVideoName);

    final isSuccessOperation = await AudioProcessor.applyAudioEffects(
      inputPath: originalVideoOutputPath!,
      outputPath: effectedPath,
      settings: selectedEffectPreset.settings,
    );

    if (isSuccessOperation) {
      effectedVideoOutputPath = effectedPath;

      _updateAppliedEffects();
      _updateEffectOperationState(EffectOperationEnum.loaded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AudioProcessorInherited(this, widget: widget.child);
  }
}
