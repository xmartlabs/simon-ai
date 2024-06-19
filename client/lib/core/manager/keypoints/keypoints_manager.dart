import 'package:dartx/dartx.dart';
import 'package:simon_ai/core/manager/keypoints/movenet_points.dart';

abstract class KeyPointsManager {
  Future<Pair<double, List<KeyPointData>>?> processFrame(dynamic newFrame);

  Future<void> init();
}
