part of 'camera_hand_cubit.dart';

@freezed
class CameraHandState with _$CameraHandState {
  const factory CameraHandState.state({
    @Default(null) Stream<dynamic>? gestureStream,
  }) = _CameraHandState;
}
