part of 'camera_hand_cubit.dart';

@freezed
class CameraHandState with _$CameraHandState {
  const factory CameraHandState.state({
    HandLandmarksData? handData,
    @Default(null) Stream<dynamic>? movenetResultStream,
  }) = _CameraHandState;
}
