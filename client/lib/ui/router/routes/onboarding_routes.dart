import 'package:auto_route/auto_route.dart';
import 'package:simon_ai/ui/router/app_router.dart';

abstract interface class NavegableRoute {
  String get route;
}

class OnboardingRoutes implements NavegableRoute {
  static const String onboarding = 'onboarding';
  static const String onboardingHandlerRoute = OnboardingHandlerRoute.name;
  static const String registerUserRoute = RegisterUserRoute.name;
  static const String registerUsernameRoute = RegisterUsernameRoute.name;
  static const String tutorialExplanationRoute = TutorialExplanationRoute.name;
  static const String tutorialExampleRoute = TutorialExampleRoute.name;

  @override
  String get route => onboardingHandlerRoute;

  static AutoRoute providerRoutes() => AutoRoute(
        page: EmptyRouteRoute.page,
        path: onboarding,
        children: [
          AutoRoute(
            initial: true,
            path: registerUserRoute,
            page: RegisterUserRoute.page,
          ),
          AutoRoute(
            path: registerUsernameRoute,
            page: RegisterUsernameRoute.page,
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
