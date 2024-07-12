import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_repository.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  final GameRepository _gameRepository = DiProvider.get();
  late StreamSubscription<GameResponse> _gameStreamSubscription;
  final Stopwatch _stopwatch = Stopwatch();

  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
            currentSequence: [],
            currentRound: 0,
            gameDuration: Duration.zero,
            gameState: GameState.initial,
            currentHandValueIndex: 0,
          ),
        ) {
    _stopwatch.start();
    Future.delayed(const Duration(seconds: 2), startCountdown);
  }
  final int _maxRounds = 5;

  bool isLastHandGesture() =>
      state.currentHandValueIndex == state.currentSequence!.length - 1;

  void startNewSequence() {
    if (state.currentRound == _maxRounds) return endGame();
    final newSequence = [
      ...state.currentSequence!,
      _generateRandomUniqueHandGesture(),
    ];
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

  Stream<HandGesture> get currentSequenceStream =>
      Stream.fromIterable(state.currentSequence!).asyncMap((gesture) async {
        await Future.delayed(const Duration(milliseconds: 1500));
        return gesture;
      }).doOnDone(() => Future.delayed(const Duration(seconds: 3), startGame));

  int advanceSequence() {
    final currentHandValueIndex = state.currentHandValueIndex! + 1;
    if (currentHandValueIndex >= state.currentSequence!.length) {
      return currentHandValueIndex;
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
    if (state.currentRound == _maxRounds) return endGame();
    emit(
      state.copyWith(
        gameState: GameState.countDown,
      ),
    );
  }

  void startGame() {
    _gameStreamSubscription =
        _gameRepository.startGame(state.currentSequence!).listen(_handleGame);
    emit(
      state.copyWith(
        gameState: GameState.playing,
        currentHandValue: state.currentSequence!.first,
        currentHandValueIndex: 0,
        userGesture: null,
      ),
    );
  }

  void _handleGame(GameResponse event) {
    if (event.isCorrect) {
      emit(
        state.copyWith(
          currentHandValue: event.gesture,
          currentHandValueIndex: state.currentHandValueIndex! + 1,
          currentPoints: event.points,
        ),
      );
      if (event.finishSequence) {
        startCountdown();
      }
    }
    if (!event.isCorrect) {
      endGame();
    }
  }

  void endGame() {
    _stopwatch.stop();
    _gameStreamSubscription.cancel();
    emit(
      state.copyWith(
        gameState: GameState.ended,
        gameDuration: _stopwatch.elapsed,
      ),
    );
  }

  HandGesture _generateRandomUniqueHandGesture() {
    HandGesture randomLetter =
        HandGesture.values[Random().nextInt(HandGesture.values.length - 1)];
    while (state.currentSequence!.contains(randomLetter)) {
      randomLetter =
          HandGesture.values[Random().nextInt(HandGesture.values.length)];
    }
    return randomLetter;
  }

  @override
  Future<void> close() {
    _gameStreamSubscription.cancel();
    return super.close();
  }
}
