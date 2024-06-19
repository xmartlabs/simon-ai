import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/core/repository/session_repository.dart';
import 'package:simon_ai/ui/onboarding/onboarding_handler_screen.dart';
import 'package:simon_ai/ui/onboarding/register_user_email/register_user_screen.dart';
import 'package:simon_ai/ui/onboarding/register_username/register_username_screen.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_example/tutorial_example_screen.dart';
import 'package:simon_ai/ui/onboarding/tutorial/tutorial_explanation/tutorial_explanation_screen.dart';
import 'package:simon_ai/ui/section/section_router.dart';
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
            page: AuthenticatedSectionRoute.page,
            path: '/',
            // guards: [UnauthenticatedGuard(sessionRepository)],
            children: [
              RedirectRoute(path: '', redirectTo: 'onboarding_email'),
              AutoRoute(path: 'onboarding_email', page: RegisterUserRoute.page),
              AutoRoute(
                path: 'onboarding_username',
                page: RegisterUsernameRoute.page,
              ),
              AutoRoute(
                path: 'finish_registration',
                page: OnboardingHandlerRoute.page,
              ),
              AutoRoute(
                path: 'onboarding_tutorial',
                page: TutorialExplanationRoute.page,
              ),
              AutoRoute(
                path: 'onboarding_example',
                page: TutorialExampleRoute.page,
              ),
              AutoRoute(path: 'welcome', page: WelcomeRoute.page),
            ],
          ),
        ];
}
