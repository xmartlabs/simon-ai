import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/hand_models/hand_detector/hand_detector_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_tracking/hand_tracking_classifier.dart';
import 'package:simon_ai/core/hand_models/keypoints/image_utils.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/hand_classifier_isolate_data.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HandTrackingIsolateUtils {
  static const _logTimes = false;

  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: 'HandClassifierIsolate',
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((data) {
      if (data is HandClasifierIsolateData) {
        final ModelHandler<HandTrackingInput, HandLandmarksResultData>
            handTrackingClassifier = HandTrackingClassifier(
          interpreters: [
            Interpreter.fromAddress(data.interpreterAddressList.first),
          ],
          predefinedAnchors: data.anchors,
        );
        final ModelHandler<img.Image, HandDetectorResultData>
            handDetectorClassifier = HandDetectorClassifier(
          interpreters: [
            Interpreter.fromAddress(data.interpreterAddressList.last),
          ],
          predefinedAnchors: data.anchors,
        );
        final stopwatch = Stopwatch()..start();
        var image = ImageUtils.convertCameraImage(data.cameraImage)!;
        if (Platform.isAndroid) {
          image = img.copyRotate(image, angle: 270);
          image = img.flipHorizontal(image);
        }
        stopwatch.stop();
        final elapsedToProcessImage = stopwatch.elapsedMilliseconds;
        stopwatch.start();
        _processModels(
          handDetectorClassifier,
          image,
          handTrackingClassifier,
          data,
        ).then((_) {
          if (_logTimes) {
            Logger.d('Process image $elapsedToProcessImage ms, process model '
                '${stopwatch.elapsedMilliseconds}ms');
          }
          stopwatch.stop();
        });
      }
    });
  }

  static Future<void> _processModels(
    ModelHandler<img.Image, HandDetectorResultData> handDetectorClassifier,
    img.Image image,
    ModelHandler<HandTrackingInput, HandLandmarksResultData>
        handTrackingClassifier,
    HandClasifierIsolateData data,
  ) async {
    final handDetector = await handDetectorClassifier.performOperations(image);
    return handTrackingClassifier
        .performOperations((image, handDetector)).then((result) {
      data.responsePort.send(result);
    });
  }
}
