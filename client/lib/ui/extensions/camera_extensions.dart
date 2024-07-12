import 'dart:ui';

import 'package:camera/camera.dart';

extension ResolutionPresetExtension on ResolutionPreset {
  Size get size {
    switch (this) {
      case ResolutionPreset.low:
        return const Size(320, 240);
      case ResolutionPreset.medium:
        return const Size(640, 480);
      case ResolutionPreset.high:
        return const Size(1280, 720);
      case ResolutionPreset.veryHigh:
        return const Size(1920, 1080);
      case ResolutionPreset.ultraHigh:
        return const Size(3840, 2160);
      //Depends on device
      case ResolutionPreset.max:
        return const Size(3840, 2160);
    }
  }
}
