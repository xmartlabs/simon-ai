import 'package:simon_ai/ui/router/app_router.dart';

extension AppRouterExtensions on AppRouter {
  Future<bool> popTopMost() => topMostRouter().maybePop();
}
