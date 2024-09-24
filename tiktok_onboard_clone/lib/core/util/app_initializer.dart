import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tiktok_onboard_clone/locator.dart';

final class AppInitializer {
  const AppInitializer._();

  static void showSplash(WidgetsBinding widgetsBinding) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  static void removeSplash() {
    FlutterNativeSplash.remove();
  }

  static Future<void> initLocalization() async {
    await EasyLocalization.ensureInitialized();
  }

  static Future<void> setupLocator() async {
    await setupDependencies();
  }
}
