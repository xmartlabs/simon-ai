import 'dart:async';
import 'dart:math';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameRepository {
  final StreamController<HandGesutre> _gameController = BehaviorSubject();

  final StreamController<GameResponse> _simulationController =
      BehaviorSubject();

  final StreamController<SequenceStatus> _sequenceController =
      BehaviorSubject();

  int points = 0;

  Stream<GameResponse> get gameStream => _simulationController.stream;

  Stream<SequenceStatus> get sequenceStream => _sequenceController.stream;

  Stream<HandGesutre> _fakeMokedGestures(List<HandGesutre> sequence) =>
      Stream.fromIterable(sequence).asyncMap((gesture) async {
        await Future.delayed(const Duration(milliseconds: 1000));
        return gesture;
      });

  HandGesutre getGestureAt(List<HandGesutre> gameSequence, int n) {
    // Calcular el grupo
    final int group = ((sqrt(8 * n + 1) - 1) ~/ 2).toInt();
    // Calcular la posición del índice dentro del grupo
    final int pos = n - (group * (group + 1)) ~/ 2;
    // Obtener el carácter correspondiente
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
        points: points += 5,
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

  void dispose() {
    _gameController.close();
    _simulationController.close();
  }

  void resetGame() {
    points = 0;
    _sequenceController.add(SequenceStatus.complete);
  }
}

enum SequenceStatus { correct, wrong, incomplete, complete }

typedef GameResponse = ({
  HandGesutre gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
