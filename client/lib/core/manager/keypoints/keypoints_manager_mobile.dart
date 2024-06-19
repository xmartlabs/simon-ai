import 'dart:async';
import 'dart:isolate';

import 'package:dartx/dartx.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager.dart';
import 'package:simon_ai/core/manager/keypoints/movenet_classifier.dart';
import 'package:simon_ai/core/manager/keypoints/movenet_isolate.dart';
import 'package:simon_ai/core/manager/keypoints/movenet_points.dart';

class KeyPointsMobileManager implements KeyPointsManager {
  late MoveNetClassifier classifier;
  late MoveNetIsolateUtils isolate;
  var currentFrame = 0;
  var lastCurrentFrame = 0;

  @override
  Future<void> init() async {
    isolate = MoveNetIsolateUtils();
    await isolate.start();
    classifier = MoveNetClassifier();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentFrame = this.currentFrame;
      Logger.d('FPS: ${currentFrame - lastCurrentFrame}');
      lastCurrentFrame = currentFrame;
    });
  }

  @override
  Future<Pair<double, List<KeyPointData>>> processFrame(
    dynamic newFrame,
  ) async {
    final isolateData = IsolateData(newFrame, classifier.interpreter.address);
    final keypoints = await _inference(isolateData);
    // Logger.d('Keypoints: $keypoints');
    currentFrame++;
    final result = processKeypoints(keypoints.second);
    return Pair(keypoints.first, result);
  }

  Future<Pair<double, List<double>>> _inference(IsolateData isolateData) async {
    final responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    final result = await responsePort.first;
    // Logger.d('Isolate response: $result');
    return result;
  }

  List<KeyPointData> processKeypoints(List<double>? keypoints) {
    final result = <KeyPointData>[];
    if (keypoints != null &&
        keypoints.length == (HandLandmark.values.length * 3)) {
      for (var i = 0; i < HandLandmark.values.length * 3; i += 3) {
        result.add(
          KeyPointData(
            x: keypoints[i + 1],
            y: keypoints[i + 0],
            z: keypoints[i + 2],
          ),
        );
      }
    }
    return result;
  }
}
