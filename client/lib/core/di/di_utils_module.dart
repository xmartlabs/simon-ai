import 'package:get_it/get_it.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/ui/router/app_router.dart';

class UtilsDiModule {
  UtilsDiModule._privateConstructor();

  static final UtilsDiModule _instance = UtilsDiModule._privateConstructor();

  factory UtilsDiModule() => _instance;

  void setupModule(GetIt locator) => locator._setupModule();
}

extension _GetItDiModuleExtensions on GetIt {
  void _setupModule() {
    registerLazySingleton(() => AppRouter(get()));
    registerLazySingleton<KeyPointsMobileManager>(KeyPointsMobileManager.new);
    registerLazySingleton<KeyPointsManager>(
      () => get<KeyPointsMobileManager>(),
    );
  }
}
