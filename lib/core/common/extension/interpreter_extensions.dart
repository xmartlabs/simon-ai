import 'dart:io';

import 'package:tflite_flutter/tflite_flutter.dart';

extension InterpreterExtensions on List<Interpreter> {
  Interpreter get handDetectorInterpreter => this[1];

  Interpreter get handTrackingInterpreter => first;

  Interpreter get handGestureEmbedderInterpreter => this[2];

  Interpreter get handCannedGestureInterpreter => this[3];
}

extension InterpreterOptionsExtensions on InterpreterOptions {
  void defaultOptions(int index) {
    if (Platform.isAndroid) {
      if (index % 2 == 0) {
        addDelegate(
          GpuDelegateV2(
            options: GpuDelegateOptionsV2(
              isPrecisionLossAllowed: false,
              inferencePriority1: 2,
            ),
          ),
        );
      } else {
        addDelegate(XNNPackDelegate());
      }
    }
  }
}
