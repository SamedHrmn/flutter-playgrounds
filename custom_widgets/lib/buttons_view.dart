import 'package:custom_widgets/widget/button/inset_button.dart';
import 'package:flutter/material.dart';

class ButtonsView extends StatefulWidget {
  ButtonsView({Key? key}) : super(key: key);

  @override
  State<ButtonsView> createState() => _ButtonsViewState();
}

class _ButtonsViewState extends State<ButtonsView> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe7ecef),
      appBar: AppBar(
        title: Text("Buttons"),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: InsetButton(
                isInset: _isPressed,
                onTap: () {
                  setState(() {
                    _isPressed = !_isPressed;
                  });
                },
              )),
        ],
      ),
    );
  }
}
