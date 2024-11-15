import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'llm_inference_platform_interface.dart';

class MethodChannelLlmInference extends LlmInferencePlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('llm_inference/method');

  @override
  Future<void> close() async {
    await methodChannel.invokeMethod("close");
  }

  @override
  Future<void> initialize() async {
    await methodChannel.invokeMethod("initialize");
  }

  @override
  Future<void> run(String prompt) async {
    await methodChannel.invokeMethod("run", prompt);
  }
}
