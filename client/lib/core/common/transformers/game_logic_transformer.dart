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
class GameLogicTransformer
    extends StreamTransformerBase<HandGestureWithPosition, GameResponse> {
  final List<HandGesture> gameSequence;
  final _pointForSuccess = 5;

  GameLogicTransformer(this.gameSequence);

  @override
  Stream<GameResponse> bind(Stream<HandGestureWithPosition> stream) =>
      stream.scan<List<HandGestureWithPosition>>(
        (accumulated, value, index) => [...accumulated, value],
        [],
      ).map(
        (currentSequence) {
          final previousSequencePoints =
              (((gameSequence.length - 1) * gameSequence.length / 2) *
                      _pointForSuccess)
                  .toInt();
          final actualSequencePoints =
              (currentSequence.length - 1) * _pointForSuccess;
          final currentPoints = previousSequencePoints + actualSequencePoints;
          final isCorrect = gameSequence
              .sublist(0, currentSequence.length)
              .fold(
                true,
                (bool acc, gesture) =>
                    acc &&
                    gesture ==
                        currentSequence[gameSequence.indexOf(gesture)].gesture,
              );
          return (
            gesture: currentSequence.last,
            points:
                isCorrect ? currentPoints + _pointForSuccess : currentPoints,
            finishSequence: currentSequence.length == gameSequence.length,
            isCorrect: isCorrect,
          );
        },
      );
}
