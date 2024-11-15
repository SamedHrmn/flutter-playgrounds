import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llm_inference/llm_inference.dart';
import 'package:llm_inference_example/main.dart';

mixin ChatViewManager on State<ChatView> {
  List<ChatModel> chatModels = [];
  ChatModel currentChat = ChatModel.empty();
  late StreamSubscription<LlmResponse?> llmResponseSubscription;
  LlmResponse? llmResponse;
  bool modelReady = false;

  late final TextEditingController textEditingController;

  void addResponse(String response) {
    setState(() {
      final chatModel = chatModels.last;
      final lastResponse = chatModel.response ?? "";
      currentChat = chatModel.copyWith(response: lastResponse + response, chatViewState: ChatViewState.loaded);
      final itemIndex = chatModels.indexWhere((element) => element == chatModel);
      chatModels[itemIndex] = currentChat;
    });
  }

  void addPrompt(String prompt) {
    setState(() {
      currentChat = ChatModel.empty();
      currentChat = currentChat.copyWith(prompt: prompt, chatViewState: ChatViewState.loading);
      chatModels.add(currentChat);
    });
  }

  void clearChat() {
    setState(() {
      chatModels.clear();
    });
  }

  Future<void> initializeLlm() async {
    await LlmInference.initialize(modelStatus: (bool modelReady) {
      setState(() {
        this.modelReady = modelReady;
      });
    });

    llmResponseSubscription = LlmInference.llmResponseStream.listen(
      (event) {
        if (event != null && event.partialResult != null) {
          addResponse(event.partialResult!);
        }
      },
    );
  }

  Future<void> generateResponse() async {
    final prompt = textEditingController.value.text;
    addPrompt(prompt);
    textEditingController.clear();

    try {
      await LlmInference.run(prompt: prompt);
    } catch (e) {
      llmResponse = null;
      setState(() {
        currentChat = ChatModel.error(prompt);
      });
    }
  }

  Future<void> close() async {
    await LlmInference.close();
    llmResponseSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    textEditingController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    initializeLlm();
  }

  @override
  void dispose() async {
    await close();
    textEditingController.dispose();
    super.dispose();
  }
}

enum ChatViewState {
  initial,
  loading,
  loaded,
  error,
}

enum ChatRole {
  prompt,
  response,
}

class ChatModel {
  final String? prompt;
  final String? response;
  final ChatViewState chatViewState;
  late final DateTime date;

  factory ChatModel.empty() => ChatModel(prompt: null, response: null);
  factory ChatModel.error(String prompt) => ChatModel(prompt: prompt, response: null, chatViewState: ChatViewState.error);

  ChatModel({
    required this.prompt,
    required this.response,
    this.chatViewState = ChatViewState.initial,
  }) {
    date = DateTime.now();
  }

  ChatModel copyWith({
    String? prompt,
    String? response,
    ChatViewState? chatViewState,
  }) {
    return ChatModel(
      prompt: prompt ?? this.prompt,
      response: response ?? this.response,
      chatViewState: chatViewState ?? this.chatViewState,
    );
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.prompt == prompt && other.response == response && other.chatViewState == chatViewState;
  }

  @override
  int get hashCode {
    return prompt.hashCode ^ response.hashCode ^ chatViewState.hashCode;
  }
}
