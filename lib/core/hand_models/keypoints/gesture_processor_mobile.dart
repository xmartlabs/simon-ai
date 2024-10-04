import 'dart:async';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:simon_ai/core/hand_models/hand_canned_gesture/hand_canned_gesture_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_detector/hand_detector_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_gesture_classifier/hand_tracking_isolate.dart';
import 'package:simon_ai/core/hand_models/hand_gesture_classifier/hand_tracking_points.dart';
import 'package:simon_ai/core/hand_models/hand_gesture_embedder/hand_gesture_embedder_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_tracking/hand_tracking_classifier.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/anchor.dart';
import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/hand_classifier_isolate_data.dart';
import 'package:simon_ai/core/model/hand_classifier_result_data.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';
import 'package:simon_ai/gen/assets.gen.dart';

class GestureMobileProcessor implements GestureProcessor {
  late ModelHandler handTrackingClassifier;
  late ModelHandler handDetectorClassifier;
  late ModelHandler handGestureEmbedderClassifier;
  late ModelHandler handCannedGestureClassifier;
  late HandTrackingIsolate isolate;
  var _currentFrame = 0;
  var _lastCurrentFrame = 0;
  Timer? _fpsTimer;

  final int processorIndex;
  late List<Anchor> anchors;

  @override
  int fps = 0;

  GestureMobileProcessor(this.processorIndex);

  @override
  Future<void> init() async {
    isolate = HandTrackingIsolate();
    anchors = await loadAnchorsFromCsv(Assets.models.anchors);

    await isolate.start();
    handTrackingClassifier =
        HandTrackingClassifier(processorIndex: processorIndex);
    handDetectorClassifier =
        HandDetectorClassifier(processorIndex: processorIndex);
    handGestureEmbedderClassifier =
        HandGestureEmbedderClassifier(processorIndex: processorIndex);
    handCannedGestureClassifier =
        HandCannedGestureClassifier(processorIndex: processorIndex);
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentFrame = _currentFrame;
      fps = currentFrame - _lastCurrentFrame;
      _lastCurrentFrame = currentFrame;
    });
  }

  @override
  Future<void> close() async {
    isolate.dispose();
    _fpsTimer?.cancel();
  }

  @override
  Future<HandLandmarksData> processFrame(
    dynamic newFrame,
  ) async {
    final resultData = await _inference(newFrame);
    _currentFrame++;
    final processedKeyPoints = _processKeypoints(resultData.keyPoints);
    return (
      confidence: resultData.confidence,
      gestureConfidence: resultData.gestureConfidence,
      keyPoints: processedKeyPoints,
      gesture: resultData.gesture,
      cropData: resultData.cropData,
    );
  }

  Future<List<Anchor>> loadAnchorsFromCsv(String filePath) async {
    final csvData = await rootBundle.loadString(filePath);
    final List<Anchor> anchors = [];

    final lines = csvData.split('\n');

    for (final line in lines) {
      final values = line.split(',');
      if (values.length == 4) {
        final anchor = (
          x: double.parse(values.first),
          y: double.parse(values[1]),
          w: double.parse(values[2]),
          h: double.parse(values[3]),
        );
        anchors.add(anchor);
      }
    }

    return anchors;
  }

  Future<HandClassifierResultData> _inference(dynamic newFrame) async {
    final responsePort = ReceivePort();
    final HandClassifierIsolateData isolateData = (
      cameraImage: newFrame,
      processorIndex: processorIndex,
      interpreterAddressList: [
        handTrackingClassifier.interpreter,
        handDetectorClassifier.interpreter,
        handGestureEmbedderClassifier.interpreter,
        handCannedGestureClassifier.interpreter,
      ].map((interpreter) => interpreter.address).toList(),
      anchors: anchors,
      responsePort: responsePort.sendPort
    );
    isolate.sendPort.send(isolateData);
    return await responsePort.first;
  }

  List<Coordinates> _processKeypoints(List<double>? keypoints) {
    final result = <Coordinates>[];
    if (keypoints != null &&
        keypoints.length == (HandLandmark.values.length * 3)) {
      for (var i = 0; i < HandLandmark.values.length * 3; i += 3) {
        final Coordinates keyPointData = (
          x: keypoints[i + 1],
          y: keypoints[i + 0],
        );
        result.add(keyPointData);
      }
    }
    return result;
  }
}
