import 'package:equatable/equatable.dart';

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

class KeyPointData extends Equatable {
  const KeyPointData({
    required this.x,
    required this.y,
    required this.z,
  });

  final double x;
  final double y;
  final double z;

  @override
  String toString() => '($x, $y, $z)';

  @override
  List<Object> get props => [x, y, z];
}
