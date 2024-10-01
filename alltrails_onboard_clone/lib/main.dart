import 'package:alltrails_onboard_clone/core/constants/route_path_constants.dart';
import 'package:alltrails_onboard_clone/core/enum/route_enum.dart';
import 'package:alltrails_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:alltrails_onboard_clone/core/navigation/app_navigation_observer.dart';
import 'package:alltrails_onboard_clone/core/theme/app_theme.dart';
import 'package:alltrails_onboard_clone/core/util/app_initializer.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/features/auth/view/sign_up_view.dart';
import 'package:alltrails_onboard_clone/features/auth/view/welcome_view.dart';
import 'package:alltrails_onboard_clone/features/paywall/paywall_view.dart';
import 'package:alltrails_onboard_clone/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  await AppInitializer.setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePathConstants.initialPath,
      navigatorKey: getIt<AppNavigationManager>().navigatorKey,
      navigatorObservers: [AppNavigatiorObserver()],
      theme: AppTheme.defaultTheme,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        );
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RoutePathConstants.initialPath:
            return MaterialPageRoute(builder: (context) => const InitialView(), settings: const RouteSettings(name: RoutePathConstants.initialPath));
          case RoutePathConstants.welcomeViewPath:
            return MaterialPageRoute(builder: (context) => const WelcomeView(), settings: const RouteSettings(name: RoutePathConstants.welcomeViewPath));
          case RoutePathConstants.signUpViewPath:
            return MaterialPageRoute(builder: (context) => const SignUpView(), settings: const RouteSettings(name: RoutePathConstants.signUpViewPath));
          case RoutePathConstants.paywallViewPath:
            return MaterialPageRoute(builder: (context) => const PaywallView(), settings: const RouteSettings(name: RoutePathConstants.paywallViewPath));
          default:
        }
        return null;
      },
      home: const InitialView(),
    );
  }
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
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
      AppSizer.init(context, figmaWidth: 428, figmaHeight: 926);
      getIt<AppNavigationManager>().navigateTo(RouteEnum.welcomeViewPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
