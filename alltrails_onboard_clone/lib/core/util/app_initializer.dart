import 'package:alltrails_onboard_clone/locator.dart';

final class AppInitializer {
  const AppInitializer._();

  static Future<void> setupDependencies() async {
    await setupLocator();
  }
}
