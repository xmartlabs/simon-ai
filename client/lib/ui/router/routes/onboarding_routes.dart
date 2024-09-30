import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/ui/router/app_router.dart';

abstract interface class NavegableRoute {
  String get route;
}

class OnboardingRoutes implements NavegableRoute {
  static const String onboarding = 'onboarding';
  static const String onboardingHandlerRoute = OnboardingHandlerRoute.name;
  static const String registerUserRoute = RegisterPlayerEmailRoute.name;
  static const String registerUsernameRoute = RegisterPlayerNameRoute.name;
  static const String tutorialExplanationRoute = TutorialExplanationRoute.name;
  static const String tutorialExampleRoute = TutorialExampleRoute.name;
  static const String adminAreaRoute = AdminAreaRoute.name;

  @override
  String get route => onboardingHandlerRoute;

  static AutoRoute providerRoutes() => AutoRoute(
        page: EmptyRouteRoute.page,
        path: onboarding,
        children: [
          AutoRoute(
            initial: true,
            page: RegisterPlayerSectionRoute.page,
            children: [
              AutoRoute(
                initial: true,
                path: registerUserRoute,
                page: RegisterPlayerEmailRoute.page,
              ),
              AutoRoute(
                path: registerUsernameRoute,
                page: RegisterPlayerNameRoute.page,
              ),
            ],
          ),
          AutoRoute(
            path: adminAreaRoute,
            page: AdminAreaRoute.page,
          ),
          AutoRoute(
            path: onboardingHandlerRoute,
            page: OnboardingHandlerRoute.page,
          ),
          AutoRoute(
            path: tutorialExplanationRoute,
            page: TutorialExplanationRoute.page,
          ),
          AutoRoute(
            path: tutorialExampleRoute,
            page: TutorialExampleRoute.page,
          ),
        ],
      );
}
