import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/image_utils.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/hand_models/hand_gesture_classifier/hand_classifier.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/hand_classifier_isolate_data.dart';
import 'package:simon_ai/core/model/hand_classifier_result_data.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HandTrackingIsolate {
  static const _logTimes = false;

  final ReceivePort _receivePort = ReceivePort();
  late SendPort _sendPort;
  late Isolate _isolate;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: 'HandClassifierIsolate',
    );
    _sendPort = await _receivePort.first;
  }

  void dispose() {
    _receivePort.close();
    _isolate.kill();
  }

  static void entryPoint(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    port.listen((data) {
      if (data is HandClassifierIsolateData) {
        final MultipleModelHandler<img.Image, HandClassifierResultData>
            handClassifier = HandClassifier(
          processorIndex: data.processorIndex,
          predefinedAnchors: data.anchors,
          interpreters: data.interpreterAddressList
              .map((address) => Interpreter.fromAddress(address))
              .toList(),
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
        handClassifier.performOperations(image).then((result) {
          data.responsePort.send(result);
          if (_logTimes) {
            Logger.d('Process image $elapsedToProcessImage ms, process model '
                '${stopwatch.elapsedMilliseconds}ms');
          }
          stopwatch.stop();
        });
      }
    });
  }
}
