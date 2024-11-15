import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'llm_inference_platform_interface.dart';

typedef LlmModelStatus = void Function(bool modelReady);

class LlmInference {
  static Isolate? _llmIsolate;
  static SendPort? _sendPort;
  static final ReceivePort _receivePort = ReceivePort();
  static const eventChannel = EventChannel("llm_inference/event");
  static late Stream<LlmResponse?> llmResponseStream;

  static Future<void> initialize({required LlmModelStatus modelStatus}) async {
    modelStatus.call(false);

    if (_llmIsolate != null) return;

    final rootIsolateToken = RootIsolateToken.instance!;
    _llmIsolate = await Isolate.spawn(_runLlmIsolate, [rootIsolateToken, _receivePort.sendPort]);

    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        _initialize(modelStatus: modelStatus);
      }
    });

    llmResponseStream = eventChannel.receiveBroadcastStream().map((event) {
      return LlmResponse.fromMap(event);
    });
  }

  static Future<void> _initialize({required LlmModelStatus modelStatus}) async {
    final responsePort = ReceivePort();
    _sendPort!.send(_IsolateMethodData.toMap(
      method: "initialize",
      responsePort: responsePort.sendPort,
    ));

    await for (var msg in responsePort) {
      if (msg is bool) {
        modelStatus.call(msg);
        responsePort.close();
        break;
      }
    }
  }

  static Future<void> _runLlmIsolate(List<dynamic> args) async {
    final rootIsolateToken = args[0] as RootIsolateToken;
    final mainSendPort = args[1] as SendPort;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);

    isolateReceivePort.listen(
      (message) async {
        final mapMessage = message as Map;

        switch (mapMessage["method"]) {
          case "initialize":
            await LlmInferencePlatform.instance.initialize();
            final responsePort = mapMessage["responsePort"] as SendPort;
            responsePort.send(true);
            break;
          case "run":
            var prompt = mapMessage["arg"] as String;
            await LlmInferencePlatform.instance.run(prompt);
            break;
          case "close":
            await LlmInferencePlatform.instance.close();
            break;
          default:
        }
      },
    );
  }

  static Future<void> run({required String prompt}) async {
    _sendPort?.send(
      _IsolateMethodData.toMap(
        arg: prompt,
        method: "run",
      ),
    );
  }

  static Future<void> close() async {
    _sendPort?.send(_IsolateMethodData.toMap(method: "close"));
    _receivePort.close();
    _llmIsolate?.kill(priority: Isolate.immediate);
    _llmIsolate = null;
    _sendPort = null;
  }
}

class LlmResponse {
  final String? partialResult;
  final bool? done;

  LlmResponse({required this.partialResult, required this.done});

  factory LlmResponse.fromMap(Map<Object?, Object?>? json) {
    return LlmResponse(
      partialResult: json?["partialResult"] as String?,
      done: json?["done"] as bool?,
    );
  }
}

class _IsolateMethodData {
  const _IsolateMethodData._();

  static Map<String, dynamic> toMap({
    dynamic arg,
    required String method,
    SendPort? responsePort,
  }) {
    return {
      "arg": arg,
      "method": method,
      "responsePort": responsePort,
    };
  }
}
