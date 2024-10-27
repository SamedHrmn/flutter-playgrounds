import '../constant/route_constants.dart';

enum RouteEnum {
  initialView(RouteConstants.initialPath),
  appView(RouteConstants.appViewPath);

  final String path;
  const RouteEnum(this.path);
}
