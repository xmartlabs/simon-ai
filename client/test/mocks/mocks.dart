import 'package:mocktail/mocktail.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';

class MockGestureProcessorPool extends Mock implements GestureProcessorPool {
  @override
  final List<GestureProcessor> processors = [];
  @override
  int fps = 0;

  @override
  Future<void> init() async {}
}
