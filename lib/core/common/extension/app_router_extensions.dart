import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/ui/router/app_router.dart';

extension AppRouterExtensions on AppRouter {
  Future<bool> popTopMost() => topMostRouter().maybePop();

  Future<dynamic> navigateTopMost(PageRouteInfo<dynamic> pageRoute) =>
      topMostRouter().navigate(pageRoute);
}
