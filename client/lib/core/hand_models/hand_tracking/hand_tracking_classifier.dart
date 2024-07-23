import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/hand_classifier_model_data.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef HandTrackingInput = ({
  img.Image image,
  HandDetectorResultData cropData
});

class HandTrackingClassifier
    implements ModelHandler<HandTrackingInput, HandLandmarksResultData> {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final ModelMetadata model =
      (path: Assets.models.handLandmarksDetector, inputSize: 224);

  late Interpreter _interpreter;
  @override
  Interpreter get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handTrackingOutputLocations;
  ImageProcessor? _handTrackingImageProcessor;

  final stopwatch = Stopwatch();

  HandTrackingClassifier({
    Interpreter? interpreter,
  }) {
    loadModel(interpreter: interpreter);
  }

  Future<Interpreter> _createModelInterpreter() {
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
    return Interpreter.fromAsset(model.path, options: options);
  }

  @override
  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ?? await _createModelInterpreter();
      final outputHandTrackingTensors = _interpreter.getOutputTensors();

      handTrackingOutputLocations = outputHandTrackingTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (_logInit && interpreter == null) {
        final handTrackingInputTensors = _interpreter.getInputTensors();

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
      ..loadImage(input.image);
    stopwatch.stop();
    final processImageTime = stopwatch.elapsedMilliseconds;
    stopwatch.start();
    final croppedProcessedImage = getHandTrackingProcessedImage(
      handTrackingTensorImage,
      model.inputSize,
      input.cropData,
    );

    _runHandTrackingModel(croppedProcessedImage);

    final result = parseLandmarkData(input);

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
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  HandLandmarksResultData parseLandmarkData(
    HandTrackingInput input,
  ) {
    final (:image, :cropData) = input;
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
      x = ((data[0 + i] / model.inputSize) *
                  (cropData.w.clamp(0, image.width).toInt()) +
              cropData.x.clamp(0, max(0, image.width - cropData.w)).toInt()) *
          positionXCorrection;
      y = ((data[1 + i] / model.inputSize) *
              cropData.h.clamp(0, image.height).toInt()) +
          cropData.y.clamp(0, max(0, image.height - cropData.h)).toInt();
      z = data[2 + i];
      result.addAll([y, x, z]);
    }
    return (confidence: confidence, keyPoints: result);
  }
}
