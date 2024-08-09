import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';

abstract interface class KeyPointsManager {
  Future<HandLandmarksData> processFrame(dynamic newFrame);

  Future<void> init();
}
