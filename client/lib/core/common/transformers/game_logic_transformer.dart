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
  int _points = 0;
  final _pointForSuccess = 5;

  GameLogicTransformer(this.gameSequence);

  @override
  Stream<GameResponse> bind(Stream<HandGestureWithPosition> stream) =>
      stream.scan<List<HandGestureWithPosition>>(
        (accumulated, value, index) => [...accumulated, value],
        [],
      ).map(
        (currentSequence) {
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
            points: isCorrect ? _points += _pointForSuccess : _points,
            finishSequence: currentSequence.length == gameSequence.length,
            isCorrect: isCorrect,
          );
        },
      );
}
