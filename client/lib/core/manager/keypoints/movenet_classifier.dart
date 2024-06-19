import 'dart:io';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:image/image.dart' as img;
import 'package:simon_ai/core/common/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MoveNetClassifier {
  static const bool _logInit = true;
  static const bool _logResultTime = false;
  static const bool useLightingModel = true;

  static const int lightingModelInputSize = 224;
  static const int thunderModelInputSize = 224;

  static const lightingModelName = 'hand_landmarks_detector.tflite';
  static const thunderModelName = 'hand_landmarks_detector.tflite';

  static String get _modelName =>
      useLightingModel ? lightingModelName : thunderModelName;

  static int get _targetSize =>
      useLightingModel ? lightingModelInputSize : thunderModelInputSize;

  late Interpreter _interpreter;

  Map<int, Object> outputs = {};
  late Tensor outputTensor;

  final stopwatch = Stopwatch();

  MoveNetClassifier({Interpreter? interpreter}) {
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
      'assets/models/$_modelName',
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

  img.Image getProcessedImage(img.Image inputImage) {
    final padSize = max(inputImage.height, inputImage.width);

    final paddedImage = img.Image(width: padSize, height: padSize);

    final int offsetX = (padSize - inputImage.width) ~/ 2;
    final int offsetY = (padSize - inputImage.height) ~/ 2;

    for (int x = 0; x < inputImage.width; x++) {
      for (int y = 0; y < inputImage.height; y++) {
        final int paddedX = x + offsetX;
        final int paddedY = y + offsetY;
        if (paddedX < paddedImage.width && paddedY < paddedImage.height) {
          final pixel = inputImage.getPixelSafe(x, y);
          final color = img.ColorFloat16.rgba(
            pixel.r.toInt(),
            pixel.g.toInt(),
            pixel.b.toInt(),
            pixel.a.toInt(),
          );
          paddedImage.setPixel(paddedX, paddedY, color);
        } else {
          throw ArgumentError(
            'Pixel coordinates are out of bounds for the padded image.',
          );
        }
      }
    }
    final processedImage =
        img.copyResize(paddedImage, width: _targetSize, height: _targetSize);

    return processedImage;
  }

  Future<Pair<double, List<double>>> performOperations(img.Image image) async {
    stopwatch.start();

    final inputImage = getProcessedImage(image);
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
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        },
      ),
    );
    final inputs = [imageMatrix];
    outputs = <int, Object>{
      0: [List<double>.filled(outputTensor.shape[1], 0.0)],
      1: [List<double>.filled(outputTensor.shape[0], 0.0)],
      2: [List<double>.filled(outputTensor.shape[0], 0.0)],
      3: [List<double>.filled(outputTensor.shape[1], 0.0)],
    };
    interpreter.runForMultipleInputs([inputs], outputs);
  }

  Pair<double, List<double>> parseLandmarkData(img.Image image) {
    final data = (outputs.values.elementAt(0) as List<List<double>>).first;
    final confidence =
        (outputs.values.elementAt(1) as List<List<double>>).first.first;
    final result = <double>[];
    double x;
    double y;
    double z;

    final padY = max(0, (image.width - image.height) / 2);
    final padX = max(0, (image.height - image.width) / 2);

    for (var i = 0; i < 63; i += 3) {
      x = (data[0 + i] - (padX / image.width * 224)) / 224 * image.width;
      y = (data[1 + i] - (padY / image.height * 224)) / 224 * image.height;
      z = data[2 + i];
      result.addAll([y, x, z]);
    }
    return Pair(confidence, result);
  }

  Interpreter get interpreter => _interpreter;
}
