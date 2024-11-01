/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/mario_coin_sound.mp3
  String get marioCoinSound => 'assets/audio/mario_coin_sound.mp3';

  /// List of all assets
  List<String> get values => [marioCoinSound];
}

class $AssetsModelsGen {
  const $AssetsModelsGen();

  /// File path: assets/models/anchors.csv
  String get anchors => 'assets/models/anchors.csv';

  /// File path: assets/models/canned_gesture_classifier.tflite
  String get cannedGestureClassifier =>
      'assets/models/canned_gesture_classifier.tflite';

  /// File path: assets/models/gesture_embedder.tflite
  String get gestureEmbedder => 'assets/models/gesture_embedder.tflite';

  /// File path: assets/models/hand_detector.tflite
  String get handDetector => 'assets/models/hand_detector.tflite';

  /// File path: assets/models/hand_landmarks_detector.tflite
  String get handLandmarksDetector =>
      'assets/models/hand_landmarks_detector.tflite';

  /// List of all assets
  List<String> get values => [
        anchors,
        cannedGestureClassifier,
        gestureEmbedder,
        handDetector,
        handLandmarksDetector
      ];
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
  static const $AssetsModelsGen models = $AssetsModelsGen();
}
