import 'package:image/image.dart' as img;
import 'package:simon_ai/core/hand_models/hand_detector/hand_detector_classifier.dart';
import 'package:simon_ai/core/hand_models/hand_tracking/hand_tracking_classifier.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/anchor.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HandClassifier
    implements MultipleModelHandler<img.Image, HandLandmarksResultData> {
  late final List<Interpreter> _interpreters;
  late final HandDetectorClassifier handDetectorClassifier;
  late final HandTrackingClassifier handTrackingClassifier;
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
      interpreter: interpreters.last,
      predefinedAnchors: predefinedAnchors,
    );
    handTrackingClassifier = HandTrackingClassifier(
      interpreter: interpreters.first,
    );
  }

  @override
  Future<HandLandmarksResultData> performOperations(input) async {
    final cropData = await handDetectorClassifier.performOperations(input);
    return handTrackingClassifier.performOperations(
      (image: input, cropData: cropData),
    );
  }
}
