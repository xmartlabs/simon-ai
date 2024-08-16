import 'dart:async';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';
import 'package:simon_ai/core/repository/user_repository.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  final GameManager _gameHandler = DiProvider.get();
  late StreamSubscription<GameResponse> _gameStreamSubscription;
  final Stopwatch _gameDuration = Stopwatch();
  final UserRepository _userRepository = DiProvider.get();
  Stream<HandGesture> get sequenceStream => _sequenceController.stream;
  StreamController<HandGesture> _sequenceController =
      StreamController<HandGesture>.broadcast();
  final audioPlayer = AudioPlayer();

  final Duration durationBetweenDisplayedGestures = const Duration(seconds: 1);

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
    audioPlayer.setSource(AssetSource('audio/mario_coin_sound.mp3'));

    Future.delayed(const Duration(seconds: 2), startCountdown);
  }
  final int _maxRounds = 8;

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
      _sequenceController.add(value);
      await Future.delayed(durationBetweenDisplayedGestures);
    }
    startGame();
  }

  void restartGame() {
    _gameDuration.start();
    _gameHandler.restartStream();
    _sequenceController.close();
    _sequenceController = StreamController<HandGesture>.broadcast();
    emit(
      state.copyWith(
        currentPoints: 0,
        currentSequence: [],
        currentRound: 0,
        gameState: GameState.initial,
        currentHandValueIndex: 0,
      ),
    );
    Future.delayed(const Duration(seconds: 2), startCountdown);
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
        audioPlayer
          ..resume()
          ..setPlaybackRate(2);
        _gameStreamSubscription.cancel();
        startNewSequence();
      }
    }
    if (!event.isCorrect) {
      endGame();
    }
  }

  void endGame() {
    _gameDuration.stop();
    _gameStreamSubscription.cancel();
    final currentUser = _userRepository.gameUser!;
    _userRepository.updateUser(
      currentUser.copyWith(
        points: state.currentPoints,
      ),
    );
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

  void toggleDebug(bool value) => emit(state.copyWith(showDebug: value));

  @override
  Future<void> close() {
    _gameStreamSubscription.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
