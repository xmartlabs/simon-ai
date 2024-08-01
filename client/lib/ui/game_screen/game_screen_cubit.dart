import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  final GameManager _gameHandler = DiProvider.get();
  late StreamSubscription<GameResponse> _gameStreamSubscription;
  final Stopwatch _gameDuration = Stopwatch();
  Stream<HandGesture> get sequenceStream => _sequenceController.stream;
  final _sequenceController = StreamController<HandGesture>.broadcast();

  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
            currentSequence: [],
            currentRound: 0,
            gameState: GameState.initial,
            currentHandValueIndex: 0,
          ),
        ) {
    _gameDuration.start();
    Future.delayed(const Duration(seconds: 2), startCountdown);
  }
  final int _maxRounds = 3;

  bool isLastHandGesture() =>
      state.currentHandValueIndex == state.currentSequence!.length - 1;

  void startNewSequence() {
    if (state.currentRound == _maxRounds) return endGame();
    final newSequence = [
      ...state.currentSequence!,
      _generateRandomUniqueHandGesture(),
    ];
    updateSequence(newSequence);
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

  Future<void> updateSequence(List<HandGesture> newSequence) async {
    for (final value in newSequence) {
      await Future.delayed(const Duration(milliseconds: 1500));
      _sequenceController.add(value);
    }
    Future.delayed(const Duration(seconds: 3), startGame);
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
    if (state.currentRound == _maxRounds) return endGame();
    emit(
      state.copyWith(
        gameState: GameState.countDown,
      ),
    );
  }

  void startGame() {
    _gameStreamSubscription =
        _gameHandler.startGame(state.currentSequence!).listen(_handleGame);
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
        _gameStreamSubscription.cancel();
        startCountdown();
      }
    }
    if (!event.isCorrect) {
      endGame();
    }
  }

  void endGame() {
    _gameDuration.stop();
    _gameStreamSubscription.cancel();
    _gameHandler.close();
    _sequenceController.close();

    emit(
      state.copyWith(
        gameState: GameState.ended,
      ),
    );
  }

  Duration get gameDuration => _gameDuration.elapsed;

  HandGesture _generateRandomUniqueHandGesture() {
    HandGesture randomLetter =
        playableGestures[Random().nextInt(playableGestures.length - 1)];
    while (state.currentSequence!.contains(randomLetter)) {
      randomLetter =
          playableGestures[Random().nextInt(playableGestures.length)];
    }
    return randomLetter;
  }

  @override
  Future<void> close() {
    _gameStreamSubscription.cancel();
    return super.close();
  }
}
