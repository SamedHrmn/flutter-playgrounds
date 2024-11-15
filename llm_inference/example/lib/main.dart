import 'package:flutter/material.dart';
import 'package:llm_inference_example/chat_view_manager.dart';
import 'package:llm_inference_example/widget/chat_list_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with ChatViewManager {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LLM Inference Flutter Plugin'),
      ),
      body: !modelReady
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Expanded(
                      child: ChatListView(chatModels: chatModels),
                    ),
                    _buildMessageInput(),
                    SizedBox(
                      height: MediaQuery.viewInsetsOf(context).bottom * 0.1,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMessageInput() {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(24),
      ),
    );

    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
        errorBorder: border,
        suffixIcon: textEditingController.value.text.isNotEmpty
            ? IconButton(
                onPressed: () async {
                  primaryFocus?.unfocus();
                  await generateResponse();
                },
                icon: const Icon(Icons.send),
              )
            : null,
      ),
    );
  }
}
