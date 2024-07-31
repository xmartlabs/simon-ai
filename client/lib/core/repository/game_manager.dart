import 'dart:async';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameManager {
  int _points = 0;

  final _pointForSuccess = 5;

  Stream<HandGesture> _fakeMokedGestures(List<HandGesture> sequence) =>
      Stream.fromIterable(sequence).delay(const Duration(seconds: 2));

  HandGesture getGestureAt(List<HandGesture> gameSequence, int n) {
    // Calculate numbers group
    final int group = ((sqrt(8 * n + 1) - 1) ~/ 2).toInt();
    // calculate index inside the group
    final int pos = n - (group * (group + 1)) ~/ 2;
    return gameSequence[pos];
  }

  Stream<GameResponse> startGame(List<HandGesture> gameSequence) {
    final simulation = List.generate(
      gameSequence.length,
      (index) => gameSequence.sublist(0, index + 1),
    );

    return _fakeMokedGestures(simulation.flatten()).scan<List<HandGesture>>(
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
