import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/anchor.dart';
import 'package:simon_ai/core/model/hand_classifier_model_data.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class HandDetectorClassifier
    implements ModelHandler<img.Image, HandDetectorResultData> {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final List<ModelMetadata> models = [
    (path: Assets.models.handDetector, inputSize: 192),
  ];

  late List<Interpreter> _interpreters;
  @override
  List<Interpreter> get interpreters => _interpreters;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handDetectorOutputLocations;
  ImageProcessor? _handDetectorImageProcessor;
  List<Anchor>? predefinedAnchors;

  final stopwatch = Stopwatch();

  HandDetectorClassifier({
    List<Interpreter>? interpreters,
    this.predefinedAnchors,
  }) {
    loadModel(interpreter: interpreters);
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

  @override
  Future<void> loadModel({List<Interpreter>? interpreter}) async {
    try {
      _interpreters = interpreter ?? await _createModelInterpreter();
      final outputHandDetectorTensors = _interpreters.first.getOutputTensors();
      handDetectorOutputLocations = outputHandDetectorTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (_logInit && interpreter == null) {
        final handDetectorInputTensors = _interpreters.first.getInputTensors();
        for (final tensor in outputHandDetectorTensors) {
          Logger.d('Hand Detector Output Tensor: $tensor');
        }
        for (final tensor in handDetectorInputTensors) {
          Logger.d('Input Hand Detector Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  @override
  Future<HandDetectorResultData> performOperations(img.Image image) async {
    stopwatch.start();

    final handDetectorTensorImage = TensorImage(TensorType.float32)
      ..loadImage(image);

    final inputImage = getHandDetectorProcessedImage(
      handDetectorTensorImage,
      models.first.inputSize,
    );
    stopwatch.stop();
    final processImageTime = stopwatch.elapsedMilliseconds;

    stopwatch.start();
    _runHandDetectorModel(inputImage);
    final croppedImageData = getCroppedImage(image);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;
    if (_logResultTime) {
      Logger.d('Process hand time $processImageTime, '
          'processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return croppedImageData;
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
    final inputSize = models.first.inputSize;
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

  void _runHandDetectorModel(TensorImage inputImage) {
    final inputs = [inputImage.buffer];

    outputs = Map.fromIterable(
      Iterable.generate(handDetectorOutputLocations.length),
      value: (index) => handDetectorOutputLocations[index].buffer,
    );
    interpreters.first.runForMultipleInputs(inputs, outputs);
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
}
