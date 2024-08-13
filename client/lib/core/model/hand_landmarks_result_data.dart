import 'package:simon_ai/core/hand_models/hand_gesture_classifier/hand_tracking_points.dart';
import 'package:simon_ai/core/model/hand_detector_result_data.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef HandLandmarksModelResultData = ({
  TensorBufferFloat screenLandmarks,
  TensorBufferFloat handednessProbability,
  TensorBufferFloat metricScaleLandmarks,
});

typedef HandLandmarksResultData = ({
  double confidence,
  List<double> keyPoints,
  HandLandmarksModelResultData tensors,
});

typedef HandLandmarksData = ({
  double confidence,
  List<KeyPointData> keyPoints,
  HandGesture gesture,
  HandDetectorResultData cropData,
});
