import 'dart:async';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameHandler {
  int _points = 0;

  final _pointForSuccess = 5;

  Stream<HandGesture> _fakeMokedGestures(List<HandGesture> sequence) =>
      Stream.fromIterable(sequence).asyncMap((gesture) async {
        await Future.delayed(const Duration(milliseconds: 2000));
        return gesture;
      });

  HandGesture getGestureAt(List<HandGesture> gameSequence, int n) {
    // Calculate numbers group
    final int group = ((sqrt(8 * n + 1) - 1) ~/ 2).toInt();
    // calculate index inside the group
    final int pos = n - (group * (group + 1)) ~/ 2;
    return gameSequence[pos];
  }

  Stream<GameResponse> startGame(List<HandGesture> gameSequence) {
    final aux = List.generate(
      gameSequence.length,
      (index) => gameSequence.sublist(0, index + 1),
    );

    return _fakeMokedGestures(aux.flatten()).scan<List<HandGesture>>(
      (accumulated, value, index) => [...accumulated, value],
      [],
    ).map(
      (currentSequence) {
        final isCorrect = currentSequence.fold(
          false,
          (value, element) =>
              element ==
              getGestureAt(gameSequence, currentSequence.indexOf(element)),
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
}

typedef GameResponse = ({
  HandGesture gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
