import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameManager {
  int _points = 0;

  final _pointForSuccess = 5;
  final _gestureDetectionTime = const Duration(milliseconds: 400);

  StreamController<HandGestureWithPosition> _gameSequenceController =
      StreamController<HandGestureWithPosition>.broadcast();

  void addGesture(HandGestureWithPosition gesture) {
    _gameSequenceController.add(gesture);
  }

  Stream<HandGestureWithPosition> get gameSequenceStream =>
      _gameSequenceController.stream
          .buffer(Stream.periodic(_gestureDetectionTime))
          .asyncMap((bufferedGestures) {
            if (bufferedGestures.isEmpty) return null;
            final HandGestureWithPosition firstGesture = bufferedGestures.first;
            final bool isConsistent = bufferedGestures
                .every((gesture) => gesture.gesture == firstGesture.gesture);
            return (isConsistent &&
                    firstGesture.gesture != HandGesture.unrecognized)
                ? firstGesture
                : null;
          })
          .whereNotNull()
          .distinct((previous, next) => previous.gesture == next.gesture)
          .asBroadcastStream();

  void close() {
    _gameSequenceController.close();
  }

  void restartStream() {
    _gameSequenceController.close();
    _gameSequenceController =
        StreamController<HandGestureWithPosition>.broadcast();
  }

  Stream<GameResponse> startGame(List<HandGesture> gameSequence) {
    restartStream();

    return gameSequenceStream.scan<List<HandGestureWithPosition>>(
      (accumulated, value, index) => [...accumulated, value],
      [],
    ).map(
      (currentSequence) {
        final isCorrect = gameSequence.sublist(0, currentSequence.length).fold(
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
}
