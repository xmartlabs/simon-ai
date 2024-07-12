part of 'game_screen_cubit.dart';

@freezed
class GameScreenState with _$GameScreenState {
  const factory GameScreenState.initial({
    required int currentPoints,
    required int currentRound,
    required GameState gameState,
    Duration? gameDuration,
    String? error,
    HandGesture? currentHandValue,
    HandGesture? userGesture,
    int? currentHandValueIndex,
    List<HandGesture>? currentSequence,
  }) = _Initial;
}

enum GameState { initial, countDown, showingSequence, playing, ended, error }
