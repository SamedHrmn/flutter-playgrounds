import 'package:flutter/material.dart';
import 'package:llm_inference_example/chat_view_manager.dart';
import 'package:llm_inference_example/widget/chat_bubble.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key, required this.chatModels});

  final List<ChatModel> chatModels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatModels.length,
      itemBuilder: (context, index) {
        final chatModel = chatModels[index];

        return Column(
          children: [
            ChatBubble(
              chatModel: chatModel,
              child: switch (chatModel.chatViewState) {
                ChatViewState.initial => const SizedBox(),
                ChatViewState.loading || ChatViewState.loaded || ChatViewState.error => Text(
                    chatModel.prompt!,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
              },
            ),
            ChatBubble(
              chatModel: chatModel,
              senderIsMe: false,
              child: switch (chatModel.chatViewState) {
                ChatViewState.initial => const SizedBox(),
                ChatViewState.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ChatViewState.error => const Center(
                    child: Text("Error!"),
                  ),
                ChatViewState.loaded => Text(
                    chatModel.response!,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
              },
            ),
          ],
        );
      },
    );
  }
}
