import 'package:tflite_flutter/tflite_flutter.dart';

abstract interface class ModelHandler<Input, Output> {
  Interpreter get interpreter;
  Future<void> loadModel({Interpreter? interpreter});
  Future<Output> performOperations(Input input);
  Future<Interpreter> createModelInterpreter();
}

abstract interface class MultipleModelHandler<Input, Output> {
  List<Interpreter> get interpreters;
  Future<void> loadModel({List<Interpreter>? interpreter});
  Future<Output> performOperations(Input input);
}
