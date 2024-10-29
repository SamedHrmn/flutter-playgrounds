import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'srgan_flutter_method_channel.dart';

abstract class SrganFlutterPlatform extends PlatformInterface {
  /// Constructs a SrganFlutterPlatform.
  SrganFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SrganFlutterPlatform _instance = MethodChannelSrganFlutter();

  /// The default instance of [SrganFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSrganFlutter].
  static SrganFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SrganFlutterPlatform] when
  /// they register themselves.
  static set instance(SrganFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initializeEnhancer();
  Future<SrganResult> enhanceImage({required Uint8List inputData});
}

class SrganResult {
  final Uint8List? imageData;
  final int? inferenceTime;

  SrganResult({this.imageData, this.inferenceTime});

  factory SrganResult.fromMap(Map<Object?, Object?>? json) {
    return SrganResult(
      imageData: json?["imageData"] as Uint8List?,
      inferenceTime: json?["inferenceTime"] as int?,
    );
  }
}
