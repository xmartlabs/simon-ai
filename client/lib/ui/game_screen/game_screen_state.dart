part of 'game_screen_cubit.dart';

@freezed
class GameScreenState with _$GameScreenState {
  const factory GameScreenState.initial({
    required int currentPoints,
    required int currentRound,
    required GameState gameState,
    String? error,
    HandGesutre? currentHandValue,
    HandGesutre? userGesture,
    int? currentHandValueIndex,
    List<HandGesutre>? currentSequence,
  }) = _Initial;
}

//TODO: Update when the HandGesture model is created
enum HandGesutre {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z
}

enum GameState { initial, countDown, showingSequence, playing, ended, error }
