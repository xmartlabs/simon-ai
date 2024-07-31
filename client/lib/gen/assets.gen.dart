/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Check.png
  AssetGenImage get check => const AssetGenImage('assets/images/Check.png');

  /// File path: assets/images/Estrella.png
  AssetGenImage get estrella =>
      const AssetGenImage('assets/images/Estrella.png');

  /// File path: assets/images/Reloj.png
  AssetGenImage get reloj => const AssetGenImage('assets/images/Reloj.png');

  /// File path: assets/images/background_green_prop.png
  AssetGenImage get backgroundGreenProp =>
      const AssetGenImage('assets/images/background_green_prop.png');

  /// File path: assets/images/background_red_prop.png
  AssetGenImage get backgroundRedProp =>
      const AssetGenImage('assets/images/background_red_prop.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [check, estrella, reloj, backgroundGreenProp, backgroundRedProp];
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

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsModelsGen models = $AssetsModelsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size = null});

  final String _assetName;

  final Size? size;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
