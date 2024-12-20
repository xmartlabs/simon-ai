import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/extension/interpreter_extensions.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/hand_classifier_model_data.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class HandGestureEmbedderClassifier
    implements ModelHandler<HandLandmarksModelResultData, TensorBufferFloat> {
  final ModelMetadata model =
      (path: Assets.models.gestureEmbedder, inputSize: 224);

  final int processorIndex;
  late Interpreter _interpreter;

  @override
  Interpreter get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handGestureEmbedderOutputLocations;

  final stopwatch = Stopwatch();

  HandGestureEmbedderClassifier({
    required this.processorIndex,
    Interpreter? interpreter,
  }) {
    loadModel(interpreter: interpreter);
  }

  @override
  Future<Interpreter> createModelInterpreter() {
    final options = InterpreterOptions()..defaultOptions(processorIndex);
    return Interpreter.fromAsset(model.path, options: options);
  }

  @override
  Future<void> loadModel({Interpreter? interpreter}) async {
    try {
      _interpreter = interpreter ?? await createModelInterpreter();
      final outputHandGestureEmbedderTensors = _interpreter.getOutputTensors();
      handGestureEmbedderOutputLocations = outputHandGestureEmbedderTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (Config.logMlHandlers && interpreter == null) {
        final handGestureEmbedderInputTensors = _interpreter.getInputTensors();
        for (final tensor in outputHandGestureEmbedderTensors) {
          Logger.d('Hand Detector Output Tensor: $tensor');
        }
        for (final tensor in handGestureEmbedderInputTensors) {
          Logger.d('Input Hand Detector Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  @override
  Future<TensorBufferFloat> performOperations(
    HandLandmarksModelResultData handLandmarksResultData,
  ) async {
    stopwatch.start();
    _runHandGestureEmbedderModel(handLandmarksResultData);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;
    if (Config.logMlHandlersVerbose) {
      Logger.d('processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return handGestureEmbedderOutputLocations.first;
  }

  void _runHandGestureEmbedderModel(
    HandLandmarksModelResultData handLandmarksResultData,
  ) {
    final inputs = [
      handLandmarksResultData.screenLandmarks.buffer,
      handLandmarksResultData.handednessProbability.buffer,
      handLandmarksResultData.metricScaleLandmarks.buffer,
    ];

    outputs = Map.fromIterable(
      Iterable.generate(handGestureEmbedderOutputLocations.length),
      value: (index) => handGestureEmbedderOutputLocations[index].buffer,
    );
    interpreter.runForMultipleInputs(inputs, outputs);
  }
}
