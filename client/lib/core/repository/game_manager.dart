import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameManager {
  int _points = 0;

  final _pointForSuccess = 5;
  final gestureDetectionTime = const Duration(milliseconds: 400);

  StreamController<HandGesture> _gameSequenceController =
      StreamController<HandGesture>.broadcast();

  void addGesture(HandGesture gesture) {
    _gameSequenceController.add(gesture);
  }

  Stream<HandGesture> get gameSequenceStream => _gameSequenceController.stream
          .buffer(Stream.periodic(gestureDetectionTime))
          .asyncMap((bufferedGestures) {
        if (bufferedGestures.isEmpty) return null;
        final HandGesture firstGesture = bufferedGestures.first;
        final bool isConsistent =
            bufferedGestures.every((gesture) => gesture == firstGesture);
        return (isConsistent && firstGesture != HandGesture.unrecognized)
            ? firstGesture
            : null;
      }).whereNotNull()
      .distinct();

  void close() {
    _gameSequenceController.close();
  }

  void restartStream() {
    _gameSequenceController.close();
    _gameSequenceController = StreamController<HandGesture>.broadcast();
  }

  Stream<GameResponse> startGame(List<HandGesture> gameSequence) {
    restartStream();

    return gameSequenceStream.scan<List<HandGesture>>(
      (accumulated, value, index) => [...accumulated, value],
      [],
    ).map(
      (currentSequence) {
        final isCorrect = gameSequence.sublist(0, currentSequence.length).fold(
              true,
              (bool acc, gesture) =>
                  acc &&
                  gesture == currentSequence[gameSequence.indexOf(gesture)],
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
