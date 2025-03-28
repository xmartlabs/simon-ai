import 'package:get_it/get_it.dart';
import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor_mobile.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor_mobile_mediapipe.dart';

class PlatformUtilsDiModule {
  PlatformUtilsDiModule._privateConstructor();

  static final PlatformUtilsDiModule _instance =
      PlatformUtilsDiModule._privateConstructor();

  factory PlatformUtilsDiModule() => _instance;

  void setupModule(GetIt locator) {
    locator._setupUtilsModule();
  }
}

extension _GetItUseCaseDiModuleExtensions on GetIt {
  void _setupUtilsModule() {
    registerLazySingleton<GestureProcessorPool>(
      () => GestureProcessorPool(
        List<GestureProcessor>.generate(
          Config.numberOfProcessors,
          (index) => GestureMediaPipeMobileProcessor(),
        ),
      ),
    );
  }
}
