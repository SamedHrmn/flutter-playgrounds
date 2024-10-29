import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'srgan_flutter_platform_interface.dart';

/// An implementation of [SrganFlutterPlatform] that uses method channels.
class MethodChannelSrganFlutter extends SrganFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('srgan_flutter');

  @override
  Future<SrganResult> enhanceImage({required Uint8List inputData}) async {
    final result = await methodChannel.invokeMethod("enhanceImage", inputData);
    return SrganResult.fromMap(result);
  }

  @override
  Future<void> initializeEnhancer() async {
    await methodChannel.invokeMethod("initializeEnhancer");
  }
}
