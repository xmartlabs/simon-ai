import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef Anchor = ({double x, double y, double w, double h});

typedef HandDetectorResultData = ({
  double confidence,
  double x,
  double y,
  double w,
  double h,
});

typedef ModelMetadata = ({
  String path,
  int inputSize,
});

extension ModelMetadataExtension on List<ModelMetadata> {
  ModelMetadata get handDetector => first;
  ModelMetadata get handLandmarksDetector => this[1];
}

class HandTrackingClassifier {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final List<ModelMetadata> models = [
    (path: Assets.models.handDetector, inputSize: 192),
    (path: Assets.models.handLandmarksDetector, inputSize: 224),
  ];

  late List<Interpreter> _interpreter;
  List<Interpreter> get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handDetectorOutputLocations;
  late List<TensorBufferFloat> handTrackingOutputLocations;
  ImageProcessor? _handDetectorImageProcessor;
  ImageProcessor? _handTrackingImageProcessor;
  List<Anchor>? predefinedAnchors;

  final stopwatch = Stopwatch();

  HandTrackingClassifier({
    List<Interpreter>? interpreter,
    this.predefinedAnchors,
  }) {
    loadModel(interpreter: interpreter);
  }

  Future<List<Interpreter>> _createModelInterpreter() {
    final options = InterpreterOptions();
    if (Platform.isAndroid) {
      options.addDelegate(
        GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
            inferencePriority1: 2,
          ),
        ),
      );
    }
    return Future.wait(
      models
          .map((model) => Interpreter.fromAsset(model.path, options: options))
          .toList(),
    );
  }

  List<double> normalizeScores(List<double> scores) =>
      scores.map((score) => 1 / (1 + exp(-score))).toList();

  Future<void> loadModel({List<Interpreter>? interpreter}) async {
    try {
      _interpreter = interpreter ?? await _createModelInterpreter();
      final outputHandDetectorTensors = _interpreter.first.getOutputTensors();
      final outputHandTrackingTensors = _interpreter[1].getOutputTensors();

      handDetectorOutputLocations = outputHandDetectorTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      handTrackingOutputLocations = outputHandTrackingTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (_logInit && interpreter == null) {
        final handDetectorInputTensors = _interpreter.first.getInputTensors();
        final handTrackingInputTensors = _interpreter[1].getInputTensors();
        for (final tensor in outputHandDetectorTensors) {
          Logger.d('Hand Detector Output Tensor: $tensor');
        }
        for (final tensor in outputHandTrackingTensors) {
          Logger.d('Hand Tracking Output Tensor: $tensor');
        }
        for (final tensor in handDetectorInputTensors) {
          Logger.d('Input Hand Detector Tensor: $tensor');
        }
        for (final tensor in handTrackingInputTensors) {
          Logger.d('Input Hand Tracking Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  Future<HandLandmarksResultData> performOperations(img.Image image) async {
    stopwatch.start();

    final handDetectorTensorImage = TensorImage(TensorType.float32)
      ..loadImage(image);
    final handTrackingTensorImage = TensorImage(TensorType.float32)
      ..loadImage(image);
    final inputImage = getHandDetectorProcessedImage(
      handDetectorTensorImage,
      models.handDetector.inputSize,
    );
    stopwatch.stop();
    final processImageTime = stopwatch.elapsedMilliseconds;

    stopwatch.start();
    _runHandDetectorModel(inputImage);
    final croppedImageData = getCroppedImage(image);
    final croppedProcessedImage = getHandTrackingProcessedImage(
      handTrackingTensorImage,
      models.handLandmarksDetector.inputSize,
      croppedImageData,
    );
    _runHandTrackingModel(croppedProcessedImage);
    final result = parseLandmarkData(image, croppedImageData);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;

    if (_logResultTime) {
      Logger.d('Process image time $processImageTime, '
          'processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return result;
  }

  HandDetectorResultData getCroppedImage(img.Image image) {
    // get the index of the highest confidence score:
    final confidenceScores =
        normalizeScores(handDetectorOutputLocations[1].getDoubleList());
    final highestScore = confidenceScores.reduce(max);
    final indexOfHighestScore = confidenceScores.indexOf(highestScore);
    final anchors = handDetectorOutputLocations.first.getDoubleList();
    final anchor =
        anchors.sublist(indexOfHighestScore * 18, indexOfHighestScore * 18 + 4);
    final predefinedAnchor = predefinedAnchors![indexOfHighestScore];
    final inputSize = models.handDetector.inputSize;
    final transformedAnchor = [
      anchor.first + inputSize * predefinedAnchor.x,
      anchor[1] + inputSize * predefinedAnchor.y,
      anchor[2] * 2,
      anchor[3] * 2,
    ];

    final result = <double>[];

    final padSize = max(image.height, image.width);
    final padY = max(0, (image.width - image.height) / 2);
    final padX = max(0, (image.height - image.width) / 2);
    double x;
    double y;

    final double padXRatio = padX / padSize;
    final double padYRatio = padY / padSize;

    final double normalizedPadX = padXRatio * inputSize;
    final double normalizedPadY = padYRatio * inputSize;

    final double adjustedModelInputSizeX = inputSize - (2 * normalizedPadX);
    final double adjustedModelInputSizeY = inputSize - (2 * normalizedPadY);

    final double normalizedDataX = transformedAnchor.first - normalizedPadX;
    final double normalizedDataY = transformedAnchor[1] - normalizedPadY;

    const paddingYFactor = 0.85;
    const paddingSizeFactor = 1.6;

    x = (normalizedDataX / adjustedModelInputSizeX) * image.width;
    y = (normalizedDataY / adjustedModelInputSizeY) *
        image.height *
        paddingYFactor;
    final normalizedWidth =
        ((transformedAnchor[2] * paddingSizeFactor) / adjustedModelInputSizeX) *
            image.width;
    final normalizedHeight =
        ((transformedAnchor[3] * paddingSizeFactor) / adjustedModelInputSizeY) *
            image.height;
    result.addAll([x, y, normalizedWidth, normalizedHeight]);

    return (
      confidence: highestScore,
      x: x - (normalizedWidth / 2),
      y: y - (normalizedHeight / 2),
      w: normalizedWidth,
      h: normalizedWidth,
    );
  }

  TensorImage getHandDetectorProcessedImage(
    TensorImage inputImage,
    int modelInputSize,
  ) {
    final padSize = max(inputImage.height, inputImage.width);
    _handDetectorImageProcessor ??= ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(padSize, padSize))
        .add(
          ResizeOp(
            modelInputSize,
            modelInputSize,
            ResizeMethod.NEAREST_NEIGHBOUR,
          ),
        )
        // The model works with [0.0, 1.0] float normalized inputs
        .add(NormalizeOp(0, 255.0))
        .build();
    return _handDetectorImageProcessor!.process(inputImage);
  }

  TensorImage getHandTrackingProcessedImage(
    TensorImage inputImage,
    int modelInputSize,
    HandDetectorResultData cropData,
  ) {
    _handTrackingImageProcessor ??= ImageProcessorBuilder()
        .add(
          ResizeWithCropOrPadOp(
            cropData.h.clamp(0, inputImage.height).toInt(),
            cropData.w.clamp(0, inputImage.width).toInt(),
            cropData.x.clamp(0, max(0, inputImage.width - cropData.w)).toInt(),
            cropData.y.clamp(0, max(0, inputImage.height - cropData.h)).toInt(),
          ),
        )
        .add(
          ResizeOp(
            modelInputSize,
            modelInputSize,
            ResizeMethod.NEAREST_NEIGHBOUR,
          ),
        )
        // The model works with [0.0, 1.0] float normalized inputs
        .add(NormalizeOp(0, 255.0))
        .build();
    return _handTrackingImageProcessor!.process(inputImage);
  }

  void _runHandTrackingModel(TensorImage inputImage) {
    final inputs = [inputImage.buffer];

    outputs = Map.fromIterable(
      Iterable.generate(handTrackingOutputLocations.length),
      value: (index) => handTrackingOutputLocations[index].buffer,
    );
    interpreter[1].runForMultipleInputs(inputs, outputs);
  }

  void _runHandDetectorModel(TensorImage inputImage) {
    final inputs = [inputImage.buffer];

    outputs = Map.fromIterable(
      Iterable.generate(handDetectorOutputLocations.length),
      value: (index) => handDetectorOutputLocations[index].buffer,
    );
    interpreter.first.runForMultipleInputs(inputs, outputs);
  }

  HandLandmarksResultData parseLandmarkData(
    img.Image image,
    HandDetectorResultData cropData,
  ) {
    final data = handTrackingOutputLocations.first.getDoubleList();
    final confidence = handTrackingOutputLocations[1].getDoubleList().first;

    final result = <double>[];
    double x;
    double y;
    double z;

    const landmarksOutputDimensions = 63;
    // TODO correct calculations to remove this hardcoded correction
    const positionYCorrection = 0.98;

    for (var i = 0; i < landmarksOutputDimensions; i += 3) {
      x = ((data[0 + i] / models.handLandmarksDetector.inputSize) *
                  (cropData.w.clamp(0, image.width).toInt()) +
              cropData.x.clamp(0, max(0, image.width - cropData.w)).toInt()) *
          positionYCorrection;
      y = ((data[1 + i] / models.handLandmarksDetector.inputSize) *
              cropData.h.clamp(0, image.height).toInt()) +
          cropData.y.clamp(0, max(0, image.height - cropData.h)).toInt();
      z = data[2 + i];
      result.addAll([y, x, z]);
    }
    return (confidence: confidence, keyPoints: result);
  }
}
