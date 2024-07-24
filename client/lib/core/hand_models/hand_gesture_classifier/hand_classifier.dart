import 'package:image/image.dart' as img;
import 'package:simon_ai/core/hand_models/hand_canned_gesture/hand_canned_gesture_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_detector/hand_detector_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_gesture_embedder/hand_gesture_embedder_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_tracking/hand_tracking_classifier.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/anchor.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HandClassifier
    implements MultipleModelHandler<img.Image, HandClassifierResultData> {
  late final List<Interpreter> _interpreters;
  late final HandDetectorClassifier handDetectorClassifier;
  late final HandTrackingClassifier handTrackingClassifier;
  late final HandGestureEmbedderClassifier handGestureEmbedderClassifier;
  late final HandCannedGestureClassifier handCannedGestureClassifier;
  List<Anchor>? predefinedAnchors;

  HandClassifier({
    List<Interpreter>? interpreters,
    this.predefinedAnchors,
  }) : _interpreters = interpreters ?? [] {
    loadModel(interpreter: interpreters);
  }

  @override
  List<Interpreter> get interpreters => _interpreters;

  @override
  Future<void> loadModel({List<Interpreter>? interpreter}) async {
    handDetectorClassifier = HandDetectorClassifier(
      interpreter: interpreters[1],
      predefinedAnchors: predefinedAnchors,
    );
    handTrackingClassifier = HandTrackingClassifier(
      interpreter: interpreters.first,
    );
    handGestureEmbedderClassifier = HandGestureEmbedderClassifier(
      interpreter: interpreters[2],
    );
    handCannedGestureClassifier = HandCannedGestureClassifier(
      interpreter: interpreters[3],
    );
  }

  @override
  Future<HandClassifierResultData> performOperations(input) async {
    final cropData = await handDetectorClassifier.performOperations(input);
    final handLandmarksResult = await handTrackingClassifier
        .performOperations((image: input, cropData: cropData));
    final gestureVector = await handGestureEmbedderClassifier
        .performOperations(handLandmarksResult.tensors);
    return handCannedGestureClassifier.performOperations(gestureVector).then(
          (gesture) => Future.value(
            (
              confidence: handLandmarksResult.confidence,
              keyPoints: handLandmarksResult.keyPoints,
              gesture: gesture
            ),
          ),
        );
  }
}
