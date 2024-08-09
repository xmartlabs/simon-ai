import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/game_screen/game_screen.dart';
import 'package:simon_ai/ui/onboarding/onboarding_handler_screen.dart';
import 'package:simon_ai/ui/onboarding/register_user_email/register_user_screen.dart';
import 'package:simon_ai/ui/onboarding/register_username/register_username_screen.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_example/tutorial_example_screen.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_explanation/tutorial_explanation_screen.dart';
import 'package:simon_ai/ui/router/app_router_guards.dart';
import 'package:simon_ai/ui/router/common/empty_router_page.dart';
import 'package:simon_ai/ui/router/routes/onboarding_routes.dart';
import 'package:simon_ai/ui/section/section_router.dart';

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
              RedirectRoute(
                path: '',
                redirectTo: OnboardingRoutes.onboarding,
              ),
              OnboardingRoutes.providerRoutes(),
              AutoRoute(path: GameRoute.name, page: GameRoute.page),
            ],
          ),
          AutoRoute(
            page: AuthenticatedSectionRoute.page,
            guards: [AuthenticatedGuard(sessionRepository)],
            path: '/',
            children: [
              RedirectRoute(path: '', redirectTo: GameRoute.name),
              AutoRoute(path: GameRoute.name, page: GameRoute.page),
            ],
          ),
        ];
}
