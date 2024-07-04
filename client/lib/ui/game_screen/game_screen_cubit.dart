import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_repository.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  final GameRepository _gameRepository = DiProvider.get();
  late final StreamSubscription<HandGesutre> _gameStreamSubscription;
  late final StreamSubscription<SequenceStatus> _sequenceStreamSubscription;
  late Timer _gameSimulationTimer;
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
    _gameStreamSubscription = _gameRepository.gameStream.listen((event) {
      if (state.gameState == GameState.playing) {
        if (event == state.currentSequence![state.currentHandValueIndex!]) {
          emit(
            state.copyWith(
              userGesture: event,
              currentPoints: _gameRepository.points,
            ),
          );
        }
      }
    });
    _sequenceStreamSubscription =
        _gameRepository.sequenceStream.distinct().listen((event) {
      print(event);

      if (event == SequenceStatus.complete) {
        startCountdown();
      }
      if (event == SequenceStatus.wrong) {
        endGame();
      }
      if (event == SequenceStatus.correct) {
        Future.delayed(const Duration(seconds: 1), () {
          print('Advance sequence');
          if (state.gameState == GameState.playing &&
              state.currentHandValueIndex! < state.currentSequence!.length) {
            final advanceSequence2 = advanceSequence();
            _gameRepository
                .takeSnapShot(state.currentSequence![advanceSequence2]);
          }
        });
        return;
      }
      if (event == SequenceStatus.incomplete) {
        emit(
          state.copyWith(
            gameState: GameState.error,
            error: 'Incomplete sequence',
          ),
        );
      }
    });
  }
  final int _maxRounds = 3;

  bool get isLastHandGesture =>
      state.currentHandValueIndex == state.currentSequence!.length - 1;

//!Temporary, update to use better state transitions and different widgets
  void startNewSequence() {
    if (state.currentRound == _maxRounds) return endGame();
    final newSequence = [
      ...state.currentSequence!,
      _generateRandomUniqueHandGesture(),
    ];
    _gameRepository.cacheCurrentSequence(newSequence);
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
    Future.delayed(const Duration(seconds: 1), takeSnapshot);
  }

  void takeSnapshot() {
    if (state.gameState == GameState.playing &&
        state.currentHandValueIndex! < state.currentSequence!.length) {
      _gameRepository
          .takeSnapShot(state.currentSequence![state.currentHandValueIndex!]);
    }
  }

  void endGame() {
    _gameSimulationTimer.cancel();
    _stopwatch.stop();
    emit(
      state.copyWith(
        gameState: GameState.ended,
        gameDuration: _stopwatch.elapsed,
      ),
    );
  }

  int get currentRound => state.currentRound;

  int get currentPoints => state.currentPoints;

  HandGesutre _generateRandomUniqueHandGesture() {
    HandGesutre randomLetter =
        HandGesutre.values[Random().nextInt(HandGesutre.values.length - 1)];
    while (state.currentSequence!.contains(randomLetter)) {
      randomLetter =
          HandGesutre.values[Random().nextInt(HandGesutre.values.length)];
    }
    return randomLetter;
  }

  @override
  Future<void> close() {
    _gameStreamSubscription.cancel();
    _sequenceStreamSubscription.cancel();
    // _gameSimulationTimer.cancel();
    return super.close();
  }
}
