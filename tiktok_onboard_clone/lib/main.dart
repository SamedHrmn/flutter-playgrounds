import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/constant/route_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/route_enum.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_observer.dart';
import 'package:tiktok_onboard_clone/core/theme/app_theme.dart';
import 'package:tiktok_onboard_clone/core/util/app_initializer.dart';

import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_view.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_view.dart';
import 'package:tiktok_onboard_clone/locator.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  AppInitializer.showSplash(widgetsBinding);
  await AppInitializer.setupLocator();
  await AppInitializer.initLocalization();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<AppNavigationManager>().navigatorKey,
      theme: AppTheme.light,
      navigatorObservers: [AppNavigatiorObserver()],
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteConstants.initialPath:
            return MaterialPageRoute(
              builder: (context) => const InitializeView(),
              settings: const RouteSettings(name: RouteConstants.initialPath),
            );
          case RouteConstants.authViewPath:
            return MaterialPageRoute(
              builder: (context) => const AuthView(),
              settings: const RouteSettings(name: RouteConstants.authViewPath),
            );
          case RouteConstants.authOnboardViewPath:
            return MaterialPageRoute(
              builder: (context) => const AuthOnboardView(),
              settings: const RouteSettings(name: RouteConstants.authOnboardViewPath),
            );
          default:
            return null;
        }
      },
      home: const InitializeView(),
    );
  }
}

class InitializeView extends StatefulWidget {
  const InitializeView({super.key});

  @override
  State<InitializeView> createState() => _InitializeViewState();
}

class _InitializeViewState extends State<InitializeView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppSizer.init(context, figmaWidth: 428, figmaHeight: 926);
      AppInitializer.removeSplash();
      getIt<AppNavigationManager>().navigateTo(RouteEnum.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
