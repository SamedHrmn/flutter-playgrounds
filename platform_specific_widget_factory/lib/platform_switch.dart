// ignore_for_file: implementation_imports, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_specific_widget_factory/widget_factory.dart';

class SwitchPlatform extends WidgetFactory {
  bool _switchValue = true;
  final void Function(bool value) onChanged;

  SwitchPlatform({required this.onChanged});

  void _changeSwitch(void Function(void Function()) setState, bool value) {
    setState(() {
      _switchValue = value;
    });
  }

  @override
  Widget createAndroidWidget(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Switch(
          value: _switchValue,
          onChanged: (value) {
            _changeSwitch(setState, value);
          },
        );
      },
    );
  }

  @override
  Widget createiOSWidget(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return CupertinoSwitch(
          value: _switchValue,
          onChanged: (value) {
            _changeSwitch(setState, value);
          },
        );
      },
    );
  }
}
