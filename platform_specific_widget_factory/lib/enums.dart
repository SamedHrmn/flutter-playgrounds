// ignore_for_file: constant_identifier_names

import 'package:platform_specific_widget_factory/main.dart';

enum PlatformEnum {
  ANDROID,
  IOS,
}

bool get isPlatformIOS => platformEnum == PlatformEnum.IOS;
