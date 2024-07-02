import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
            //TODO: Change to hand gesture sequence
            currentSequence: [],
            currentRound: 0,
            gameState: GameState.initial,
            currentHandValueIndex: 0,
          ),
        ) {
    Future.delayed(const Duration(seconds: 3), startCountdown);
  }
  final int _maxRounds = 4;

  bool get isLastHandGesture =>
      state.currentHandValueIndex == state.currentSequence!.length - 1;

//!Temporary, update to use better state transitions and different widgets
  void startNewSequence() {
    if (state.currentRound == _maxRounds) return endGame();
    final newValue = _generateRandomUniqueHandGesture();
    final newSequence = [...state.currentSequence!, newValue];
    emit(
      state.copyWith(
        gameState: GameState.showingSequence,
        currentSequence: newSequence,
        currentRound: state.currentRound + 1,
        currentHandValue: newSequence.first,
        currentHandValueIndex: 0,
      ),
    );
  }

  int advanceSequence() {
    final currentHandValueIndex = state.currentHandValueIndex! + 1;
    if (currentHandValueIndex >= state.currentSequence!.length) {
      return -1;
    }
    emit(
      state.copyWith(
        currentHandValue: state.currentSequence![currentHandValueIndex],
        currentHandValueIndex: currentHandValueIndex,
      ),
    );
    return currentHandValueIndex;
  }

  void startCountdown() {
    emit(
      state.copyWith(
        gameState: GameState.countDown,
      ),
    );
  }

  void startGame() {
    emit(
      state.copyWith(
        gameState: GameState.playing,
        currentHandValue: state.currentSequence!.first,
        currentHandValueIndex: 0,
        userGesture: null,
      ),
    );
  }

  void endGame() {
    emit(
      state.copyWith(
        gameState: GameState.ended,
      ),
    );
  }

  HandGesutre _generateRandomUniqueHandGesture() {
    HandGesutre randomLetter =
        HandGesutre.values[Random().nextInt(HandGesutre.values.length - 1)];
    while (state.currentSequence!.contains(randomLetter)) {
      randomLetter =
          HandGesutre.values[Random().nextInt(HandGesutre.values.length)];
    }
    return randomLetter;
  }
}
