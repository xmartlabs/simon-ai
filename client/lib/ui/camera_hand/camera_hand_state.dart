part of 'camera_hand_cubit.dart';

@freezed
class CameraHandState with _$CameraHandState {
  const factory CameraHandState.state({
    Pair<List<KeyPointData>, bool>? handData,
    @Default(null) Stream<dynamic>? movenetResultStream,
  }) = _CameraHandState;
}
