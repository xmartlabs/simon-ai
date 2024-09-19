import 'package:mocktail/mocktail.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';

class MockGestureProcessor extends Mock implements GestureProcessor {
  @override
  Future<void> init() async {}
}
