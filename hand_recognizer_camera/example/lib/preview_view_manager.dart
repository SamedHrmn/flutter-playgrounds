import 'package:flutter/material.dart';
import 'package:hand_recognizer_camera/hand_recognizer_camera.dart';
import 'package:hand_recognizer_camera/result_bundle.dart';
import 'package:hand_recognizer_camera_example/main.dart';
import 'package:permission_handler/permission_handler.dart';

mixin PreviewViewManager on State<PreviewView> {
  bool hasCameraPermission = false;
  int? textureId;
  ResultBundle? resultBundle;
  double scaleFactorX = 1;
  double scaleFactorY = 1;
  late final HandRecognizerCamera handRecognizerCamera;

  @override
  void initState() {
    super.initState();

    handRecognizerCamera = HandRecognizerCamera();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasCameraPermission = await checkCameraPermission();
      if (hasCameraPermission) {
        await initCamera();
        await startImageStream();
      }
    });
  }

  @override
  void dispose() {
    handRecognizerCamera.close();
    super.dispose();
  }

  void _updateCameraPermission(bool v) {
    setState(() {
      hasCameraPermission = v;
    });
  }

  void _updateTextureId(int? id) {
    setState(() {
      textureId = id;
    });
  }

  void _onHandDetect(ResultBundle resultBundle) {
    setState(() {
      this.resultBundle = resultBundle;
    });
  }

  Future<bool> checkCameraPermission() async {
    final isGranted = await Permission.camera.isGranted;
    if (!isGranted) {
      final status = await Permission.camera.request();
      _updateCameraPermission(status.isGranted);
      return status.isGranted;
    }
    _updateCameraPermission(isGranted);
    return isGranted;
  }

  Future<void> initCamera() async {
    final id = await handRecognizerCamera.initializeCamera();
    _updateTextureId(id);
  }

  Future<void> startImageStream() async {
    await handRecognizerCamera.startImageStream(
      onHandDetect: _onHandDetect,
    );
  }
}
