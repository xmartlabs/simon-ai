import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

typedef HandClassifierResultData = ({
  double confidence,
  List<double> keyPoints,
  HandGesture gesture,
  HandDetectorResultData cropData,
});
