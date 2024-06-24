import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/game_screen/game_screen.dart';
import 'package:simon_ai/ui/router/app_router_guards.dart';
import 'package:simon_ai/ui/section/section_router.dart';
import 'package:simon_ai/ui/signin/signin_screen.dart';
import 'package:simon_ai/ui/welcome/welcome_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page|Screen|Router,Route',
)
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes;

  ReevaluateListenable authReevaluateListenable;

  AppRouter(SessionRepository sessionRepository)
      : authReevaluateListenable = ReevaluateListenable.stream(
          sessionRepository.status.distinct().skip(1),
        ),
        routes = [
          AutoRoute(
            page: UnauthenticatedSectionRoute.page,
            path: '/',
            guards: [UnauthenticatedGuard(sessionRepository)],
            children: [
              RedirectRoute(path: '', redirectTo: 'game'),
              AutoRoute(path: 'game', page: GameRoute.page),
              AutoRoute(path: 'login', page: SignInRoute.page),
            ],
          ),
          AutoRoute(
            page: AuthenticatedSectionRoute.page,
            guards: [AuthenticatedGuard(sessionRepository)],
            path: '/',
            children: [
              RedirectRoute(path: '', redirectTo: 'welcome'),
              AutoRoute(path: 'welcome', page: GameRoute.page),
            ],
          ),
        ];
}
