import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'llm_inference_method_channel.dart';

abstract class LlmInferencePlatform extends PlatformInterface {
  /// Constructs a LlmInferencePlatform.
  LlmInferencePlatform() : super(token: _token);

  static final Object _token = Object();

  static LlmInferencePlatform _instance = MethodChannelLlmInference();

  /// The default instance of [LlmInferencePlatform] to use.
  ///
  /// Defaults to [MethodChannelLlmInference].
  static LlmInferencePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LlmInferencePlatform] when
  /// they register themselves.
  static set instance(LlmInferencePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initialize();
  Future<void> run(String prompt);
  Future<void> close();
}
