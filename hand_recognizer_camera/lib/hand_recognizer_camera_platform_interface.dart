import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hand_recognizer_camera_method_channel.dart';

abstract class HandRecognizerCameraPlatform extends PlatformInterface {
  /// Constructs a HandRecognizerCameraPlatform.
  HandRecognizerCameraPlatform() : super(token: _token);

  static final Object _token = Object();

  static HandRecognizerCameraPlatform _instance = MethodChannelHandRecognizerCamera();

  /// The default instance of [HandRecognizerCameraPlatform] to use.
  ///
  /// Defaults to [MethodChannelHandRecognizerCamera].
  static HandRecognizerCameraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HandRecognizerCameraPlatform] when
  /// they register themselves.
  static set instance(HandRecognizerCameraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<int?> initializeCamera();
  Future<void> startImageStream();
  Future<void> close();
}
