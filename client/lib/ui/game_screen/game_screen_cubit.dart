import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';
import 'package:simon_ai/core/repository/user_repository.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  final AppRouter _appRouter = DiProvider.get();
  final GameManager _gameHandler = DiProvider.get();
  late StreamSubscription<GameResponse> _gameStreamSubscription;
  final Stopwatch _gameDuration = Stopwatch();
  final UserRepository _userRepository = DiProvider.get();
  Stream<HandGesture> get sequenceStream => _sequenceController.stream;
  StreamController<HandGesture> _sequenceController =
      StreamController<HandGesture>.broadcast();
  final audioPlayer = AudioPlayer();

  final Duration durationBetweenDisplayedGestures = const Duration(seconds: 1);
  final double playbackSpeed = 2;
  final Duration durationBeforeStartingNewSequence = const Duration(seconds: 1);
  final Duration durationOnFinishScreen = const Duration(seconds: 3);

  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
            currentSequence: [],
            currentRound: 0,
            gameState: GameState.initial,
            currentHandValueIndex: 0,
            handSequenceHistory: [],
          ),
        ) {
    _gameDuration.start();
    audioPlayer.setSource(AssetSource('audio/mario_coin_sound.mp3'));

    Future.delayed(const Duration(seconds: 2), startCountdown);
  }

  bool isLastHandGesture() =>
      state.currentHandValueIndex == state.currentSequence!.length - 1;

  void startNewSequence() {
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
    await Future.delayed(durationBetweenDisplayedGestures);
    for (final value in newSequence) {
      _sequenceController.add(value);
      await Future.delayed(durationBetweenDisplayedGestures);
    }
    startGame();
  }

  Future<void> restartGame() async {
    _gameDuration
      ..stop()
      ..start();
    await _gameHandler.close();
    await _sequenceController.close();
    _sequenceController = StreamController<HandGesture>.broadcast();
    emit(
      state.copyWith(
        currentPoints: 0,
        currentSequence: [],
        currentRound: 0,
        gameState: GameState.initial,
        currentHandValueIndex: 0,
        handSequenceHistory: [],
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
    emit(
      state.copyWith(
        gameState: GameState.countDown,
      ),
    );
  }

  void startGame() {
    _gameStreamSubscription =
        _gameHandler.startSequence(state.currentSequence!).listen(_handleGame);
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
          currentHandValue: event.gesture.gesture,
          currentHandValueIndex: state.currentHandValueIndex! + 1,
          currentPoints: event.points,
          handSequenceHistory: [
            ...state.handSequenceHistory!,
            event.gesture,
          ],
        ),
      );
      if (event.finishSequence) {
        audioPlayer
          ..resume()
          ..setPlaybackRate(playbackSpeed);
        _gameStreamSubscription.cancel();
        Future.delayed(durationBeforeStartingNewSequence, startNewSequence);
      }
    }
    if (!event.isCorrect) {
      endGame();
    }
  }

  void endGame() {
    _gameDuration.stop();
    _gameStreamSubscription.cancel();
    _sequenceController.close();
    final currentUser = _userRepository.gameUser!;
    _userRepository.updateUser(
      currentUser.copyWith(
        points: state.currentPoints,
      ),
    );
    _sequenceController.close();

    emit(
      state.copyWith(
        gameState: GameState.ended,
      ),
    );

    Future.delayed(
      durationOnFinishScreen,
      () => _appRouter.push(const LeaderboardRoute()),
    );
  }

  Duration get gameDuration => _gameDuration.elapsed;

  HandGesture _generateRandomUniqueHandGesture() {
    HandGesture randomGesture =
        playableGestures[Random().nextInt(playableGestures.length - 1)];
    while (state.currentSequence?.lastOrNull == randomGesture) {
      randomGesture =
          playableGestures[Random().nextInt(playableGestures.length)];
    }
    return randomGesture;
  }

  void toggleDebug(bool value) => emit(state.copyWith(showDebug: value));

  @override
  Future<void> close() {
    _gameStreamSubscription.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
