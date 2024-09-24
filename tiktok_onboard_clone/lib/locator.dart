import 'package:get_it/get_it.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<AppNavigationManager>(AppNavigationManager());
}
