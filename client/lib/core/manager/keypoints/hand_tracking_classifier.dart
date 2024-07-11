import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_processing/tflite_flutter_processing.dart';

class HandTrackingClassifier {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final int modelInputSize = 224;
  final String modelName = Assets.models.handLandmarksDetector;

  late Interpreter _interpreter;
  Interpreter get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late List<Tensor> outputTensors;
  late List<TensorBufferFloat> outputLocations;
  ImageProcessor? _imageProcessor;

  final stopwatch = Stopwatch();

  HandTrackingClassifier({Interpreter? interpreter}) {
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
    return Interpreter.fromAsset(
      modelName,
      options: options,
    );
  }

  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ?? await _createModelInterpreter();
      outputTensors = _interpreter.getOutputTensors();
      outputLocations =
          outputTensors.map((e) => TensorBufferFloat(e.shape)).toList();
      if (_logInit && interpreter == null) {
        final inputTensors = _interpreter.getInputTensors();
        for (final tensor in outputTensors) {
          Logger.d('Output Tensor: $tensor');
        }
        for (final tensor in inputTensors) {
          Logger.d('Input Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  Future<HandLandmarksResultData> performOperations(img.Image image) async {
    stopwatch.start();

    final tensorImage = TensorImage(TensorType.float32)..loadImage(image);
    final inputImage = getProcessedImage(tensorImage);
    stopwatch.stop();
    final processImageTime = stopwatch.elapsedMilliseconds;

    stopwatch.start();
    _runModel(inputImage);
    final result = parseLandmarkData(image);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;

    if (_logResultTime) {
      Logger.d('Process image time $processImageTime, '
          'processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return result;
  }

  TensorImage getProcessedImage(TensorImage inputImage) {
    final padSize = max(inputImage.height, inputImage.width);
    _imageProcessor ??= ImageProcessorBuilder()
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
    inputImage = _imageProcessor!.process(inputImage);
    return inputImage;
  }

  void _runModel(TensorImage inputImage) {
    final inputs = [inputImage.buffer];

    outputs = Map.fromIterable(
      Iterable.generate(outputLocations.length),
      value: (index) => outputLocations[index].buffer,
    );
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  HandLandmarksResultData parseLandmarkData(img.Image image) {
    final data = outputLocations.first.getDoubleList();
    final confidence = outputLocations[2].getDoubleList().first;

    final result = <double>[];
    double x;
    double y;
    double z;

    final padSize = max(image.height, image.width);
    final padY = max(0, (image.width - image.height) / 2);
    final padX = max(0, (image.height - image.width) / 2);

    const landmarksOutputDimensions = 63;

    for (var i = 0; i < landmarksOutputDimensions; i += 3) {
      final double padXRatio = padX / padSize;
      final double padYRatio = padY / padSize;

      final double normalizedPadX = padXRatio * modelInputSize;
      final double normalizedPadY = padYRatio * modelInputSize;

      final double adjustedModelInputSizeX =
          modelInputSize - (2 * normalizedPadX);
      final double adjustedModelInputSizeY =
          modelInputSize - (2 * normalizedPadY);

      final double normalizedDataX = data[0 + i] - normalizedPadX;
      final double normalizedDataY = data[1 + i] - normalizedPadY;

      x = (normalizedDataX / adjustedModelInputSizeX) * image.width;
      y = (normalizedDataY / adjustedModelInputSizeY) * image.height;
      z = data[2 + i];
      result.addAll([y, x, z]);
    }
    return (confidence: confidence, keyPoints: result);
  }
}
