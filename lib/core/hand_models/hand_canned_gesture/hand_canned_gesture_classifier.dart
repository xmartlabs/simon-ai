import 'dart:math';

import 'package:simon_ai/core/common/config.dart';
import 'package:simon_ai/core/common/extension/interpreter_extensions.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/interfaces/model_interface.dart';
import 'package:simon_ai/core/model/hand_classifier_model_data.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/gen/assets.gen.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class HandCannedGestureClassifier
    implements ModelHandler<TensorBufferFloat, HandGesture> {
  final ModelMetadata model =
      (path: Assets.models.cannedGestureClassifier, inputSize: 128);

  late Interpreter _interpreter;
  @override
  Interpreter get interpreter => _interpreter;

  Map<int, Object> outputs = {};
  late List<TensorBufferFloat> handCannedGestureOutputLocations;

  final stopwatch = Stopwatch();

  final int processorIndex;

  HandCannedGestureClassifier({
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
      final outputHandCannedGestureTensors = _interpreter.getOutputTensors();
      handCannedGestureOutputLocations = outputHandCannedGestureTensors
          .map((e) => TensorBufferFloat(e.shape))
          .toList();
      if (Config.logMlHandlers && interpreter == null) {
        final handCannedGestureInputTensors = _interpreter.getInputTensors();
        for (final tensor in outputHandCannedGestureTensors) {
          Logger.d('Hand Detector Output Tensor: $tensor');
        }
        for (final tensor in handCannedGestureInputTensors) {
          Logger.d('Input Hand Detector Tensor: $tensor');
        }
        Logger.d('Interpreter loaded successfully');
      }
    } catch (error) {
      Logger.e('Error while creating interpreter: $error', error);
    }
  }

  @override
  Future<HandGesture> performOperations(
    TensorBufferFloat tensorBufferFloat,
  ) async {
    stopwatch.start();
    _runHandCannedGestureModel(tensorBufferFloat);

    stopwatch.stop();
    final processModelTime = stopwatch.elapsedMilliseconds;
    if (Config.logMlHandlersVerbose) {
      Logger.d('processModelTime: $processModelTime');
    }

    stopwatch.reset();
    return _processGestureResultData();
  }

  void _runHandCannedGestureModel(
    TensorBufferFloat tensorBufferFloat,
  ) {
    final inputs = [tensorBufferFloat.buffer];

    outputs = Map.fromIterable(
      Iterable.generate(handCannedGestureOutputLocations.length),
      value: (index) => handCannedGestureOutputLocations[index].buffer,
    );
    interpreter.runForMultipleInputs(inputs, outputs);
  }

  HandGesture _processGestureResultData() {
    final gesturesScore =
        handCannedGestureOutputLocations.first.getDoubleList();
    final highestScore = gesturesScore.reduce(max);
    final indexOfHighestScore = gesturesScore.indexOf(highestScore);
    return HandGesture.values[indexOfHighestScore];
  }
}
