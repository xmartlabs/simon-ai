import 'dart:async';

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
        await Future.delayed(const Duration(milliseconds: 500));
        return gesture;
      });

  // currentSequence =[A, A, B, A, B, C] // Esto es lo que tendroa que hacer
  // game sec = [A, B, C] // Esto es lo que hace esta funcion

  Stream startGame(List<HandGesutre> gameSequence) {
    final realGameSequence = gameSequence
        .map((gesture) => [gesture])
        .fold<List<List<HandGesutre>>>([], (prev, element) {
      final List<HandGesutre> newList =
          prev.isEmpty ? element : [...prev.last, ...element];
      return [...prev, newList];
    }).flatten();

    return _fakeMokedGestures(realGameSequence).scan<List<HandGesutre>>(
      (accumulated, value, index) => [...accumulated, value],
      [],
    ).map(
      (currentSequence) => (
        gesture: currentSequence.last,
        points: points,
        finishSequence: currentSequence.length == gameSequence.length,
        isCorrect: gameSequence.startsWith(currentSequence),
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
