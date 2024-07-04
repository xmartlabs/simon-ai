import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:simon_ai/core/manager/keypoints/hand_tracking_classifier.dart';

class HandTrackingIsolateUtils {
  static const _logTimes = false;

  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: 'MoveNetIsolate',
    );

    _sendPort = await _receivePort.first;
  }

  static void entryPoint(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((data) {
      if (data is IsolateData) {
        final classifier = HandTrackingClassifier(
          interpreter: Interpreter.fromAddress(data.interpreterAddress),
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

        classifier.performOperations(image).then((result) {
          data.responsePort.send(result);

          if (_logTimes) {
            Logger.d('Process image $elapsedToProcessImage ms, process model '
                '${stopwatch.elapsedMilliseconds}ms');
          }
        });
      }
    });
  }
}

/// Bundles data to pass between Isolate
typedef IsolateData = ({
  CameraImage cameraImage,
  int interpreterAddress,
  SendPort responsePort,
});
