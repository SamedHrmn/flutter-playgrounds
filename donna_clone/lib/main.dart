import 'package:donna_clone/app/constant/route_constants.dart';
import 'package:donna_clone/app/enum/route_enum.dart';
import 'package:donna_clone/app/navigation/app_navigator.dart';
import 'package:donna_clone/app/util/app_initalizer.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/cubit/explore_cubit.dart';
import 'package:donna_clone/features/home/domain/explore_repository.dart';
import 'package:donna_clone/features/home/pages/app_view.dart';
import 'package:donna_clone/locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.setupDependencies();
  await AppInitializer.initLocalization();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("en"),
      ],
      path: 'assets/translations',
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(exploreRepository: getIt<ExploreRepositoryImpl>()),
      child: MaterialApp(
        locale: context.locale,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        navigatorKey: getIt<AppNavigator>().navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const InitialView(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case RouteConstants.initialPath:
              return _createRoute(const InitialView(), settings);
            case RouteConstants.appViewPath:
              return _createRoute(const AppView(), settings);
            default:
              return _createRoute(const InitialView(), settings);
          }
        },
      ),
    );
  }

  MaterialPageRoute<dynamic> _createRoute(Widget widget, RouteSettings settings) => MaterialPageRoute(
        builder: (context) => widget,
        settings: RouteSettings(name: settings.name, arguments: settings.arguments),
      );
}

class InitialView extends StatefulWidget {
  const InitialView({super.key});

  @override
  State<InitialView> createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppSizer.init(context, figmaWidth: 428, figmaHeight: 926);
      await Future.delayed(Durations.extralong1);
      getIt<AppNavigator>().navigateTo(RouteEnum.appView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
