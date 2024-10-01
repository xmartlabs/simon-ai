import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

extension ResolutionPresetExtension on ResolutionPreset {
  Size sizeForOrientation(Orientation orientation) {
    final isPortrait = orientation == Orientation.portrait;
    switch (this) {
      case ResolutionPreset.low:
        return isPortrait ? const Size(240, 320) : const Size(320, 240);
      case ResolutionPreset.medium:
        return isPortrait ? const Size(480, 640) : const Size(640, 480);
      case ResolutionPreset.high:
        return isPortrait ? const Size(720, 1280) : const Size(1280, 720);
      case ResolutionPreset.veryHigh:
        return isPortrait ? const Size(1080, 1920) : const Size(1920, 1080);
      case ResolutionPreset.ultraHigh:
        return isPortrait ? const Size(2160, 3840) : const Size(3840, 2160);
      //Depends on device
      case ResolutionPreset.max:
        return isPortrait ? const Size(2160, 3840) : const Size(3840, 2160);
    }
  }
}
