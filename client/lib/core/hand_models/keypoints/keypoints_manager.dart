import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager_mobile.dart';

abstract interface class KeyPointsManager {
  Future<HandLandmarksData?> processFrame(dynamic newFrame);

  Future<void> init();
}
