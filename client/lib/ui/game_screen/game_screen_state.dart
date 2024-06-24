part of 'game_screen_cubit.dart';

@freezed
class GameScreenState with _$GameScreenState {
  const factory GameScreenState.initial({
    required int currentPoints,
    String? error,
    HandGesutre? currentHandValue,
    List<HandGesutre>? handGestures,
  }) = _Initial;
}

//TODO: Update when the HandGesture model is created
typedef HandGesutre = String;
