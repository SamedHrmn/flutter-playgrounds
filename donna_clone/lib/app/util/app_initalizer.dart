import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class AppInitializer {
  const AppInitializer._();

  static Future<void> setupDependencies() async {
    await setupLocator();
  }

  static Future<void> initLocalization() async {
    await EasyLocalization.ensureInitialized();
  }

  static void initSizer(
    BuildContext context, {
    required double figmaWidth,
    required double figmaHeight,
  }) {
    AppSizer.init(context, figmaWidth: figmaWidth, figmaHeight: figmaHeight);
  }
}
