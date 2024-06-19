import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/image_utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:simon_ai/core/manager/keypoints/movenet_classifier.dart';

class MoveNetIsolateUtils {
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

  static Future<void> entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      final classifier = MoveNetClassifier(
        interpreter: Interpreter.fromAddress(isolateData.interpreterAddress),
      );
      final stopwatch = Stopwatch()..start();
      var image = ImageUtils.convertCameraImage(isolateData.cameraImage)!;
      if (Platform.isAndroid) {
        image = img.copyRotate(image, angle: 270);
        image = img.flipHorizontal(image);
      }
      stopwatch.stop();
      final elapsedToProcessImage = stopwatch.elapsedMilliseconds;
      stopwatch.start();

      final result = await classifier.performOperations(image);
      isolateData.responsePort.send(result);

      if (_logTimes) {
        Logger.d('Process image $elapsedToProcessImage ms, process model '
            '${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  late SendPort responsePort;

  IsolateData(this.cameraImage, this.interpreterAddress);
}
