import 'package:get_it/get_it.dart';
import 'package:simon_ai/core/di/app_providers_module.dart';
import 'package:simon_ai/core/di/di_repository_module.dart';
import 'package:simon_ai/core/di/di_utils_mobile_module.dart';
import 'package:simon_ai/core/di/di_utils_module.dart';

abstract class DiProvider {
  static GetIt get _instance => GetIt.instance;

  static Future<void> init() async {
    // Setup app providers have to be done first
    await AppProvidersModule().setupModule(_instance);
    UtilsDiModule().setupModule(_instance);
    // TODO add conditional import when having web support
    PlatformUtilsDiModule().setupModule(_instance);
    RepositoryDiModule().setupModule(_instance);
    await _instance.allReady();
  }

  static T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) =>
      _instance.get(instanceName: instanceName, param1: param1, param2: param2);
}
