import 'dart:ui';

// The order is important, it follows the model order
enum HandLandmark {
  wrist,
  thumbCmc,
  thumbMcp,
  thumbIp,
  thumbTip,
  indexFingerMcp,
  indexFingerPip,
  indexFingerDip,
  indexFingerTip,
  middleFingerMcp,
  middleFingerPip,
  middleFingerDip,
  middleFingerTip,
  ringFingerMcp,
  ringFingerPip,
  ringFingerDip,
  ringFingerTip,
  pinkyMcp,
  pinkyPip,
  pinkyDip,
  pinkyTip,
}

typedef KeyPointData = ({
  double x,
  double y,
  double z,
});

extension MoveNetPointDataExtensions on KeyPointData {
  Offset getOffset({required Size canvasSize, required Size imageSize}) =>
      Offset(
        x / imageSize.width * canvasSize.width,
        y / imageSize.height * canvasSize.height,
      );
}
