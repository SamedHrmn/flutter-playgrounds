import 'package:donna_clone/app/navigation/app_navigator.dart';
import 'package:donna_clone/features/home/domain/explore_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerSingleton<AppNavigator>(AppNavigator());
  getIt.registerLazySingleton<ExploreRepositoryImpl>(() => ExploreRepositoryImpl());
}
