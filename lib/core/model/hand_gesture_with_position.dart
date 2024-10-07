import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

typedef HandGestureWithPosition = ({
  HandGesture gesture,
  double gestureConfidence,
  Coordinates gesturePosition,
  HandDetectorResultData boundingBox,
});
