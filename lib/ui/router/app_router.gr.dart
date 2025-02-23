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
    AdminAreaRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AdminAreaScreen(),
      );
    },
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
    GameRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const GameScreen(),
      );
    },
    LeaderboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LeaderboardScreen(),
      );
    },
    OnboardingHandlerRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingHandlerScreen(),
      );
    },
    RegisterPlayerEmailRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPlayerEmailScreen(),
      );
    },
    RegisterPlayerNameRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPlayerNameScreen(),
      );
    },
    RegisterPlayerSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const RegisterPlayerSection(),
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
  };
}

/// generated route for
/// [AdminAreaScreen]
class AdminAreaRoute extends PageRouteInfo<void> {
  const AdminAreaRoute({List<PageRouteInfo>? children})
      : super(
          AdminAreaRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdminAreaRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
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
/// [GameScreen]
class GameRoute extends PageRouteInfo<void> {
  const GameRoute({List<PageRouteInfo>? children})
      : super(
          GameRoute.name,
          initialChildren: children,
        );

  static const String name = 'GameRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LeaderboardScreen]
class LeaderboardRoute extends PageRouteInfo<void> {
  const LeaderboardRoute({List<PageRouteInfo>? children})
      : super(
          LeaderboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'LeaderboardRoute';

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
/// [RegisterPlayerEmailScreen]
class RegisterPlayerEmailRoute extends PageRouteInfo<void> {
  const RegisterPlayerEmailRoute({List<PageRouteInfo>? children})
      : super(
          RegisterPlayerEmailRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterPlayerEmailRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPlayerNameScreen]
class RegisterPlayerNameRoute extends PageRouteInfo<void> {
  const RegisterPlayerNameRoute({List<PageRouteInfo>? children})
      : super(
          RegisterPlayerNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterPlayerNameRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [RegisterPlayerSection]
class RegisterPlayerSectionRoute extends PageRouteInfo<void> {
  const RegisterPlayerSectionRoute({List<PageRouteInfo>? children})
      : super(
          RegisterPlayerSectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterPlayerSectionRoute';

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
