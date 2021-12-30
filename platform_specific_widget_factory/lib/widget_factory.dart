// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:platform_specific_widget_factory/enums.dart';

abstract class WidgetFactory<I extends Widget, A extends Widget> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return isPlatformIOS ? createiOSWidget(context) : createAndroidWidget(context);
  }

  I createiOSWidget(BuildContext context);
  A createAndroidWidget(BuildContext context);
}
