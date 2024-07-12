import 'dart:async';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameRepository {
  int points = 0;

  final _pointForSuccess = 5;

  Stream<HandGesutre> _fakeMokedGestures(List<HandGesutre> sequence) =>
      Stream.fromIterable(sequence).asyncMap((gesture) async {
        await Future.delayed(const Duration(milliseconds: 2000));
        return gesture;
      });

  HandGesutre getGestureAt(List<HandGesutre> gameSequence, int n) {
    // Calculate numbers group
    final int group = ((sqrt(8 * n + 1) - 1) ~/ 2).toInt();
    // calculate index inside the group
    final int pos = n - (group * (group + 1)) ~/ 2;
    return gameSequence[pos];
  }

  Stream<GameResponse> startGame(List<HandGesutre> gameSequence) {
    final aux = List.generate(
      gameSequence.length,
      (index) => gameSequence.sublist(0, index + 1),
    );

    return _fakeMokedGestures(aux.flatten()).scan<List<HandGesutre>>(
      (accumulated, value, index) => [...accumulated, value],
      [],
    ).map(
      (currentSequence) => (
        gesture: currentSequence.last,
        points: points += _pointForSuccess,
        finishSequence: currentSequence.length == gameSequence.length,
        isCorrect: currentSequence.fold(
          false,
          (value, element) =>
              element ==
              getGestureAt(gameSequence, currentSequence.indexOf(element)),
        ),
      ),
    );
  }
}

typedef GameResponse = ({
  HandGesutre gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
