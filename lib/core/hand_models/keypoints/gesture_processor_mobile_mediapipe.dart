import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:simon_ai/core/common/extension/string_extensions.dart';
import 'package:simon_ai/core/common/image_utils.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';



class GestureMediaPipeMobileProcessor implements GestureProcessor {
  final methodChannel = const MethodChannel('com.xmartlabs.simonai.dev/gesture');

  @override
  Future<void> close() async {}

  @override
  int get fps => 1;

  @override
  Future<void> init() async {}

  @override
  Future<HandLandmarksData> processFrame(newFrame) async {
    final stopwatch = Stopwatch()..start();
    var image = ImageUtils.convertCameraImage(newFrame)!;
    if (Platform.isAndroid) {
      image = copyRotate(image, angle: 270);
      image = flipHorizontal(image);
    }
    stopwatch.stop();
    final elapsedToProcessAndroidImage = stopwatch.elapsedMilliseconds;
    Logger.d('ANDROID $elapsedToProcessAndroidImage ms');

    stopwatch.start();

    final reSizedImage = copyResize(
      image,
      width: image.width ~/ 2,
      height: image.height ~/ 2,
    );
    final cameraImageBytes = Uint8List.fromList(encodeJpg(reSizedImage));

    stopwatch.stop();
    final elapsedToProcessImage = stopwatch.elapsedMilliseconds;
    Logger.d('ENCODING $elapsedToProcessImage ms');
    stopwatch.start();
    final String gestureId = await methodChannel.invokeMethod(
      'recognizeGesture',
      {'image': cameraImageBytes},
    );

    final elapsedToProcessModel = stopwatch.elapsedMilliseconds;
    Logger.d('MODEL $elapsedToProcessModel ms');
    stopwatch.stop();
    // TODO: get confidence and keyPoints from the model
    return (
      gestureConfidence: 0.9,
      confidence: 90.0,
      keyPoints: [(x: 0.0, y: 0.0)],
      gesture: gestureId.toHandGesture(),
      cropData: (x: 0.0, y: 0.0, w: 0.0, h: 0.0, confidence: 0.0),
    );
  }
}
