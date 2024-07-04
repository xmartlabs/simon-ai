import 'dart:async';
import 'dart:isolate';

import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager.dart';
import 'package:simon_ai/core/manager/keypoints/hand_tracking_classifier.dart';
import 'package:simon_ai/core/manager/keypoints/hand_tracking_isolate.dart';
import 'package:simon_ai/core/manager/keypoints/hand_tracking_points.dart';

typedef HandLandmarksData = ({
  double confidence,
  List<KeyPointData> keyPoints,
});

typedef HandLandmarksResultData = ({
  double confidence,
  List<double> keyPoints,
});

class KeyPointsMobileManager implements KeyPointsManager {
  late HandTrackingClassifier classifier;
  late HandTrackingIsolateUtils isolate;
  var _currentFrame = 0;
  var _lastCurrentFrame = 0;

  @override
  Future<void> init() async {
    isolate = HandTrackingIsolateUtils();
    await isolate.start();
    classifier = HandTrackingClassifier();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentFrame = _currentFrame;
      Logger.d('FPS: ${currentFrame - _lastCurrentFrame}');
      _lastCurrentFrame = currentFrame;
    });
  }

  @override
  Future<HandLandmarksData> processFrame(
    dynamic newFrame,
  ) async {
    final resultData = await _inference(newFrame);
    _currentFrame++;
    final processedKeyPoints = _processKeypoints(resultData.keyPoints);
    return (confidence: resultData.confidence, keyPoints: processedKeyPoints);
  }

  Future<HandLandmarksResultData> _inference(dynamic newFrame) async {
    final responsePort = ReceivePort();
    final IsolateData isolateData = (
      cameraImage: newFrame,
      interpreterAddress: classifier.interpreter.address,
      responsePort: responsePort.sendPort
    );
    isolate.sendPort.send(isolateData);
    return await responsePort.first;
  }

  List<KeyPointData> _processKeypoints(List<double>? keypoints) {
    final result = <KeyPointData>[];
    if (keypoints != null &&
        keypoints.length == (HandLandmark.values.length * 3)) {
      for (var i = 0; i < HandLandmark.values.length * 3; i += 3) {
        final KeyPointData keyPointData = (
          x: keypoints[i + 1],
          y: keypoints[i + 0],
          z: keypoints[i + 2],
        );
        result.add(keyPointData);
      }
    }
    return result;
  }
}
