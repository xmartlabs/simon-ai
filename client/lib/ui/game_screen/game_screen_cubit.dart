import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
            currentSequence: ['a', 'b'],
            gameState: GameState.initial,
            currentHandValueIndex: 0,
          ),
        );

//!Temporary

  void startSequence() {
    emit(
      state.copyWith(
        gameState: GameState.showingSequence,
        currentHandValue: state.currentSequence!.first,
        currentHandValueIndex: 0,
      ),
    );
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

  void generateHandGesture() {
    final List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
    final String randomLetter = alphabet[Random().nextInt(alphabet.length)];

    final newSequence = state.currentSequence!..add(randomLetter);
    emit(
      state.copyWith(
        currentHandValue: newSequence.first,
        currentHandValueIndex: 0,
        currentSequence: newSequence,
      ),
    );
  }
}
