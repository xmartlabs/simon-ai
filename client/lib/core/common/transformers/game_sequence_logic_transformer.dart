import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

/// Transforms a stream of [HandGestureWithPosition] into a stream of
/// [GameResponse].
/// The transformer will emit a [GameResponse] every time a gesture is emitted.
/// The [GameResponse] will contain the gesture, the points,
/// if the sequence is completed and if the gesture is correct.
class GameSequenceLogicTransformer
    extends StreamTransformerBase<HandGestureWithPosition, GameResponse> {
  final List<HandGesture> gameSequence;
  static const _pointForSuccess = 5;

  GameSequenceLogicTransformer(this.gameSequence);

  @override
  Stream<GameResponse> bind(Stream<HandGestureWithPosition> stream) =>
      stream.scan<List<HandGestureWithPosition>>(
        (accumulated, value, index) => [...accumulated, value],
        [],
      ).map(
        (currentSequence) {
          final isCorrect = _isCorrect(currentSequence);
          return (
            gesture: currentSequence.last,
            points: _gamePoints(isCorrect, currentSequence),
            finishSequence: currentSequence.length == gameSequence.length,
            isCorrect: isCorrect,
          );
        },
      );

  bool _isCorrect(List<HandGestureWithPosition> currentSequence) =>
      gameSequence.sublist(0, currentSequence.length).fold(
            true,
            (bool acc, gesture) =>
                acc &&
                gesture ==
                    currentSequence[gameSequence.indexOf(gesture)].gesture,
          );

  int _gamePoints(
    bool isCorrect,
    List<HandGestureWithPosition> currentSequence,
  ) {
    final previousSequencePoints =
        (((gameSequence.length - 1) * gameSequence.length / 2) *
                _pointForSuccess)
            .toInt();
    final actualSequencePoints =
        (currentSequence.length - 1) * _pointForSuccess;
    return previousSequencePoints +
        actualSequencePoints +
        (isCorrect ? _pointForSuccess : 0);
  }
}
