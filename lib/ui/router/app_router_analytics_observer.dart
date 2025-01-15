import 'package:dartx/dartx_io.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:simon_ai/core/common/extension/string_extensions.dart';
import 'package:simon_ai/ui/router/app_router.dart';

class AppRouterAnalyticsObserver extends FirebaseAnalyticsObserver {
  AppRouterAnalyticsObserver({
    required super.analytics,
  }) : super(
          routeFilter: (route) =>
              defaultRouteFilter(route) &&
              route?.settings.name?.endsWith('SectionRoute') != true &&
              route?.settings.name != EmptyRouteRoute.name,
          nameExtractor: (settings) =>
              settings.name?.removeSuffix('Route').camelCaseToSnakeCase,
        );
}
