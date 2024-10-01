import 'package:alltrails_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<AppNavigationManager>(AppNavigationManager());
}
