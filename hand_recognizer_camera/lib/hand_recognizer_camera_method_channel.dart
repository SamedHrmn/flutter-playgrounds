import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hand_recognizer_camera_platform_interface.dart';

/// An implementation of [HandRecognizerCameraPlatform] that uses method channels.
class MethodChannelHandRecognizerCamera extends HandRecognizerCameraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hand_recognizer_camera');

  @override
  Future<void> close() async {
    await methodChannel.invokeMethod("dispose");
  }

  @override
  Future<int?> initializeCamera() async {
    final id = await methodChannel.invokeMethod("initializeCamera");
    return id;
  }

  @override
  Future<void> startImageStream() async {
    await methodChannel.invokeMethod("startImageStream");
  }

  void initializeMethodCallHandler(Future<dynamic> Function(MethodCall)? handler) {
    methodChannel.setMethodCallHandler(handler);
  }
}
