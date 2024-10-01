import 'package:alltrails_onboard_clone/core/constants/route_path_constants.dart';

enum RouteEnum {
  initialPath(RoutePathConstants.initialPath),
  welcomeViewPath(RoutePathConstants.welcomeViewPath),
  signUpViewPath(RoutePathConstants.signUpViewPath),
  paywallViewPath(RoutePathConstants.paywallViewPath);

  final String path;
  const RouteEnum(this.path);
}
