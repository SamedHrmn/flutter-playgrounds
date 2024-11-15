import 'package:flutter/material.dart';
import 'package:llm_inference_example/chat_view_manager.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.senderIsMe = true,
    required this.chatModel,
    required this.child,
  });

  final bool senderIsMe;
  final Widget child;
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: senderIsMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: senderIsMe ? const Color(0xFF57C5D4) : const Color(0xFFEFF3FA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(25),
                    topRight: const Radius.circular(25),
                    bottomRight: senderIsMe ? const Radius.circular(25) : Radius.zero,
                    bottomLeft: senderIsMe ? Radius.zero : const Radius.circular(25),
                  ),
                ),
              ),
              child: child,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${chatModel.date.hour}:${chatModel.date.minute}",
              style: const TextStyle(color: Color(0xFF9093A3), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
