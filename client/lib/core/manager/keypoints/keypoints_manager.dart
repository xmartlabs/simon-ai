import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';

abstract class KeyPointsManager {
  Future<HandLandmarksData?> processFrame(dynamic newFrame);

  Future<void> init();
}
