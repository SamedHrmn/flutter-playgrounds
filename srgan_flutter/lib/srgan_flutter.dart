import 'dart:typed_data';

import 'srgan_flutter_platform_interface.dart';

class SrganFlutter {
  Future<void> initializeEnhancer() async {
    return SrganFlutterPlatform.instance.initializeEnhancer();
  }

  Future<SrganResult> enhanceImage({required Uint8List inputData}) async {
    return SrganFlutterPlatform.instance.enhanceImage(inputData: inputData);
  }
}
