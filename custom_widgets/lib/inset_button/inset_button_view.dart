import 'package:custom_widgets/inset_button/inset_button.dart';
import 'package:flutter/material.dart';

class InsetButtonView extends StatefulWidget {
  const InsetButtonView({super.key});

  @override
  State<InsetButtonView> createState() => _InsetButtonViewState();
}

class _InsetButtonViewState extends State<InsetButtonView> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7ecef),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: InsetButton(
            isInset: _isPressed,
            onTap: () {
              setState(() {
                _isPressed = !_isPressed;
              });
            },
          ),
        ),
      ),
    );
  }
}
