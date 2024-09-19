import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';

abstract interface class GestureProcessor {
  Stream<int> get fps;

  Future<HandLandmarksData> processFrame(dynamic newFrame);

  Future<void> close();

  Future<void> init();
}
