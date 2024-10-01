import 'package:image/image.dart' as img;
import 'package:simon_ai/core/model/hand_detector_result_data.dart';

typedef HandTrackingInput = ({
  img.Image image,
  HandDetectorResultData cropData
});
