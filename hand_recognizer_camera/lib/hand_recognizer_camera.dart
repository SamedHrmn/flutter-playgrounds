import 'dart:async';

import 'package:hand_recognizer_camera/hand_recognizer_camera_method_channel.dart';

import 'result_bundle.dart';

typedef HandDetectCallback = void Function(ResultBundle resultBundle);

class HandRecognizerCamera {
  final MethodChannelHandRecognizerCamera _handRecognizerCamera = MethodChannelHandRecognizerCamera();

  HandRecognizerCamera() {
    _initializeMethodCallHandler();
  }

  HandDetectCallback? _handDetectCallback;
  bool isBusy = false;

  Future<void> close() async {
    await _handRecognizerCamera.close();
  }

  Future<int?> initializeCamera() async {
    final id = _handRecognizerCamera.initializeCamera();
    return id;
  }

  Future<void> startImageStream({
    required HandDetectCallback onHandDetect,
  }) async {
    _handDetectCallback = onHandDetect;
    await _handRecognizerCamera.startImageStream();
  }

  void _initializeMethodCallHandler() {
    _handRecognizerCamera.initializeMethodCallHandler((call) async {
      if (call.method == 'onResultBundle') {
        if (!isBusy) {
          isBusy = true;
        }

        final Map<dynamic, dynamic> data = call.arguments as Map<dynamic, dynamic>;
        final resultBundle = ResultBundle.fromMap(Map<String, dynamic>.from(data));
        _handDetectCallback?.call(resultBundle);
        isBusy = false;
      }
    });
  }
}
