import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/manager/keypoints/image_utils.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HandTrackingClassifier {
  final bool _logInit = true;
  final bool _logResultTime = false;

  final int modelInputSize = 224;
  final String modelName = Assets.models.handLandmarksDetector;

  late Interpreter _interpreter;
  Interpreter get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late Tensor outputTensor;

  final stopwatch = Stopwatch();

  HandTrackingClassifier({Interpreter? interpreter}) {
    loadModel(interpreter: interpreter);
  }

  Future<Interpreter> _createModelInterpreter() {
    final options = InterpreterOptions()..threads = 4;
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

      if (_logInit && interpreter == null) {
        final inputTensors = _interpreter.getInputTensors();
        final outputTensors = _interpreter.getOutputTensors();
        for (final tensor in outputTensors) {
          Logger.d('Output Tensor: $tensor');
        }
        for (final tensor in inputTensors) {
          Logger.d('Input Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
      outputTensor = _interpreter.getOutputTensors().first;
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  Future<HandLandmarksResultData> performOperations(img.Image image) async {
    stopwatch.start();

    final inputImage = ImageUtils.getProcessedImage(image, modelInputSize);
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

  void _runModel(img.Image inputImage) {
    final imageMatrix = List.generate(
      inputImage.height,
      (y) => List.generate(
        inputImage.width,
        (x) {
          final pixel = inputImage.getPixel(x, y);
          // Normalize pixel values to [0, 1]
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        },
      ),
    );
    final inputs = [imageMatrix];
    outputs = <int, Object>{
      // Output 0: Presence of a hand in the image. A float scalar value.
      0: [List<double>.filled(outputTensor.shape[1], 0.0)],
      // Output 1: 21 3D screen landmarks normalized by image size.
      // Represented as a 1x63 tensor.Only valid when the presence score
      // (Output 0) is above a certain threshold.
      1: [List<double>.filled(outputTensor.shape.first, 0.0)],
      // Output 2: Handedness of the predicted hand. A float scalar value.
      // Only valid when the presence score (Output 0) is above a certain
      // threshold.
      2: [List<double>.filled(outputTensor.shape.first, 0.0)],
      // Output 3: 21 3D world landmarks based on the GHUM hand model.
      // Represented as a 1x63 tensor.
      // Only valid when the presence score (Output 0) is above a
      // certain threshold.
      3: [List<double>.filled(outputTensor.shape[1], 0.0)],
    };
    interpreter.runForMultipleInputs([inputs], outputs);
  }

  HandLandmarksResultData parseLandmarkData(img.Image image) {
    final data = (outputs.values.first as List<List<double>>).first;
    final confidence =
        (outputs.values.elementAt(1) as List<List<double>>).first.first;
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
