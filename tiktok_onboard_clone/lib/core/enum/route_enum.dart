import 'package:tiktok_onboard_clone/core/constant/route_constants.dart';

enum RouteEnum {
  initial(RouteConstants.initialPath),
  auth(RouteConstants.authViewPath),
  onboard(RouteConstants.onboardViewPath);

  const RouteEnum(this.path);
  final String path;
}
