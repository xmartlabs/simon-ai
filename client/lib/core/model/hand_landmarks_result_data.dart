import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef HandLandmarksModelResultData = ({
  TensorBufferFloat screenLandmarks,
  TensorBufferFloat handednessProbability,
  TensorBufferFloat metricScaleLandmarks,
});
