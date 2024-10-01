import 'dart:async';

import 'package:flutter/material.dart';

class TypingText extends StatefulWidget {
  /// The word(s) that the widget will display, typing out one after another. This list cannot be empty.
  final List<String> words;

  /// The TextStyle to apply to the text. If null, the default TextStyle for Text widgets is used.
  final TextStyle? style;

  /// The amount of time to pause between typing each letter.
  final Duration letterSpeed;

  /// The amount of time to pause between typing each word.
  final Duration wordSpeed;

  const TypingText({
    super.key,
    required this.words,
    this.style,
    this.letterSpeed = const Duration(milliseconds: 100),
    this.wordSpeed = const Duration(milliseconds: 1200),
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int wordIndex = 0;
  int charIndex = 0;
  late String currentWord;
  late String currentFullWord;
  Timer? timer;
  bool isUpdatePending = false;

  TypingState typingState = TypingState.typing;

  void resetAndStartTyping() {
    timer?.cancel(); // Cancel existing timer
    isUpdatePending = false; // Reset the flag
    setState(() {
      wordIndex = 0;
      charIndex = 0;
      currentWord = '';
      currentFullWord = widget.words.first;
      typingState = TypingState.typing;
    });
    startTyping();
  }

  void startTyping() {
    timer = Timer.periodic(widget.letterSpeed, (timer) {
      if (isUpdatePending) {
        typingState = TypingState.deleting;
      }

      if (typingState == TypingState.pausing) {
        return;
      }

      setState(() {
        if (typingState == TypingState.deleting) {
          currentWord = currentFullWord.substring(0, charIndex);
          charIndex--;
        } else {
          currentWord = currentFullWord.substring(0, charIndex);
          charIndex++;
        }

        if (charIndex < 0) {
          if (isUpdatePending) {
            resetAndStartTyping();
          } else {
            typingState = TypingState.typing;
            charIndex = 0;
            wordIndex = (wordIndex + 1) % widget.words.length;
            currentFullWord = widget.words[wordIndex];
          }
        } else if (charIndex > currentFullWord.length) {
          typingState = TypingState.pausing;
          startPause();
          charIndex = currentFullWord.length;
        }
      });
    });
  }

  void startPause() {
    Future.delayed(widget.wordSpeed, () {
      if (mounted) {
        setState(() {
          typingState = TypingState.deleting;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    assert(widget.words.isNotEmpty, 'Provide at least one word to the TypingText widget.');

    currentWord = '';
    currentFullWord = widget.words.first;
    startTyping();
  }

  @override
  void didUpdateWidget(TypingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.words != widget.words) {
      isUpdatePending = true; // Set the flag
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        currentWord,
        style: widget.style,
      ),
    );
  }
}

enum TypingState {
  typing,
  deleting,
  pausing,
}
