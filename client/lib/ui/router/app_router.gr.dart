// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthenticatedSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthenticatedSectionRouter(),
      );
    },
    EmptyRouteRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const EmptyRouterPage(),
      );
    },
    OnboardingHandlerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingHandlerScreen(),
      );
    },
    RegisterUserRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterUserScreen(),
      );
    },
    RegisterUsernameRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterUsernameScreen(),
      );
    },
    TutorialExampleRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TutorialExampleScreen(),
      );
    },
    TutorialExplanationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TutorialExplanationScreen(),
      );
    },
    UnauthenticatedSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UnauthenticatedSectionRouter(),
      );
    },
    WelcomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const WelcomeScreen(),
      );
    },
  };
}

/// generated route for
/// [AuthenticatedSectionRouter]
class AuthenticatedSectionRoute extends PageRouteInfo<void> {
  const AuthenticatedSectionRoute({List<PageRouteInfo>? children})
      : super(
          AuthenticatedSectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticatedSectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [EmptyRouterPage]
class EmptyRouteRoute extends PageRouteInfo<void> {
  const EmptyRouteRoute({List<PageRouteInfo>? children})
      : super(
          EmptyRouteRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmptyRouteRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingHandlerScreen]
class OnboardingHandlerRoute extends PageRouteInfo<void> {
  const OnboardingHandlerRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingHandlerRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingHandlerRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterUserScreen]
class RegisterUserRoute extends PageRouteInfo<void> {
  const RegisterUserRoute({List<PageRouteInfo>? children})
      : super(
          RegisterUserRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUserRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterUsernameScreen]
class RegisterUsernameRoute extends PageRouteInfo<void> {
  const RegisterUsernameRoute({List<PageRouteInfo>? children})
      : super(
          RegisterUsernameRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterUsernameRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TutorialExampleScreen]
class TutorialExampleRoute extends PageRouteInfo<void> {
  const TutorialExampleRoute({List<PageRouteInfo>? children})
      : super(
          TutorialExampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'TutorialExampleRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TutorialExplanationScreen]
class TutorialExplanationRoute extends PageRouteInfo<void> {
  const TutorialExplanationRoute({List<PageRouteInfo>? children})
      : super(
          TutorialExplanationRoute.name,
          initialChildren: children,
        );

  static const String name = 'TutorialExplanationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UnauthenticatedSectionRouter]
class UnauthenticatedSectionRoute extends PageRouteInfo<void> {
  const UnauthenticatedSectionRoute({List<PageRouteInfo>? children})
      : super(
          UnauthenticatedSectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnauthenticatedSectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
