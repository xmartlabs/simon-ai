import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/anchor.dart';
import 'package:simon_ai/core/model/hand_classifier_model_data.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef HandTrackingInput = (img.Image, HandDetectorResultData);

class HandTrackingClassifier
    implements ModelHandler<HandTrackingInput, HandLandmarksResultData> {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final List<ModelMetadata> models = [
    (path: Assets.models.handLandmarksDetector, inputSize: 224),
  ];

  late List<Interpreter> _interpreters;
  @override
  List<Interpreter> get interpreters => _interpreters;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handTrackingOutputLocations;
  ImageProcessor? _handTrackingImageProcessor;
  List<Anchor>? predefinedAnchors;

  final stopwatch = Stopwatch();

  HandTrackingClassifier({
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
      final outputHandTrackingTensors = _interpreters.first.getOutputTensors();

      handTrackingOutputLocations = outputHandTrackingTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (_logInit && interpreter == null) {
        final handTrackingInputTensors = _interpreters.first.getInputTensors();

        for (final tensor in outputHandTrackingTensors) {
          Logger.d('Hand Tracking Output Tensor: $tensor');
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

  @override
  Future<HandLandmarksResultData> performOperations(
    HandTrackingInput input,
  ) async {
    stopwatch.start();
    final handTrackingTensorImage = TensorImage(TensorType.float32)
      ..loadImage(input.$1);
    stopwatch.stop();
    final processImageTime = stopwatch.elapsedMilliseconds;
    stopwatch.start();
    final croppedProcessedImage = getHandTrackingProcessedImage(
      handTrackingTensorImage,
      models.first.inputSize,
      input.$2,
    );

    _runHandTrackingModel(croppedProcessedImage);

    final result = parseLandmarkData(input.$1, input.$2);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;
    if (_logResultTime) {
      Logger.d('Process image time $processImageTime, '
          'processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return result;
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
    interpreters[0].runForMultipleInputs(inputs, outputs);
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
    const positionXCorrection = 0.98;

    for (var i = 0; i < landmarksOutputDimensions; i += 3) {
      x = ((data[0 + i] / models.first.inputSize) *
                  (cropData.w.clamp(0, image.width).toInt()) +
              cropData.x.clamp(0, max(0, image.width - cropData.w)).toInt()) *
          positionXCorrection;
      y = ((data[1 + i] / models.first.inputSize) *
              cropData.h.clamp(0, image.height).toInt()) +
          cropData.y.clamp(0, max(0, image.height - cropData.h)).toInt();
      z = data[2 + i];
      result.addAll([y, x, z]);
    }
    return (confidence: confidence, keyPoints: result);
  }
}
