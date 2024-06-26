part of 'game_screen_cubit.dart';

@freezed
class GameScreenState with _$GameScreenState {
  const factory GameScreenState.initial({
    required int currentPoints,
    required GameState gameState,
    String? error,
    HandGesutre? currentHandValue,
    HandGesutre? userGesture,
    int? currentHandValueIndex,
    List<HandGesutre>? currentSequence,
  }) = _Initial;
}

//TODO: Update when the HandGesture model is created
typedef HandGesutre = String;

enum GameState { initial, countDown, showingSequence, playing, ended }
