import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameRepository {
  final StreamController<HandGesutre> _gameController = BehaviorSubject();

  final StreamController<SequenceStatus> _sequenceController =
      BehaviorSubject();

  List<HandGesutre> recognizedGestures = [];

  int points = 0;

  Stream<HandGesutre> get gameStream => _gameController.stream;

  Stream<SequenceStatus> get sequenceStream => _sequenceController.stream;

  final Stream<HandGesutre> _fakeMokedGestures = Stream.fromIterable([
    HandGesutre.A,
    HandGesutre.B,
    HandGesutre.C,
    HandGesutre.D,
  ]).asyncMap((gesture) async {
    await Future.delayed(const Duration(seconds: 1));
    return gesture;
  });

  // [A, A, B, A, B, C] // Esto es lo que tendroa que hacer
  // [A, B, C] // Esto es lo que hace esta funcion

  Stream<GameResponse> startGame(List<HandGesutre> gameSequence) =>
      _fakeMokedGestures.scan<List<HandGesutre>>(
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

  // Stream<bool> startGame(bool Function(List<HandGesutre>) secuenceComparator) =>
  //     _fakeMokedGestures.scan<List<HandGesutre>>(
  //       (accumulated, value, index) => [...accumulated, value],
  //       [],
  //     ).map((currentSequence) => secuenceComparator(currentSequence));

// _gameSimulationStreamSubscription =
//         Stream.fromIterable(state.currentSequence!).asyncMap((event) async {
//       await Future.delayed(const Duration(seconds: 1));
//       return event;
//     }).listen((event) {
//       _gameRepository.takeSnapShot(event);
//     });

  void dispose() {
    _gameController.close();
  }

  void resetGame() {
    recognizedGestures.clear();
    points = 0;
    _sequenceController.add(SequenceStatus.complete);
  }

  void clearRecognizedGestures() => recognizedGestures.clear();
}

enum SequenceStatus { correct, wrong, incomplete, complete }

typedef GameResponse = ({
  HandGesutre gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
