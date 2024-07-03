import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

class GameRepository {
  final StreamController<HandGesutre> _gameController = BehaviorSubject();

  final StreamController<SequenceStatus> _sequenceController =
      BehaviorSubject();

  List<HandGesutre> recognizedGestures = [];

  List<HandGesutre> currentSequence = [];

  int points = 0;

  Stream<HandGesutre> get gameStream => _gameController.stream;

  Stream<SequenceStatus> get sequenceStream => _sequenceController.stream;

  Future<void> takeSnapShot(HandGesutre gesture) async {
    addRecognizedGesture(gesture);

    if (currentSequence.length == recognizedGestures.length) {
      _sequenceController.add(SequenceStatus.complete);
      recognizedGestures.clear();

      return;
    }
    if (currentSequence[recognizedGestures.length] != recognizedGestures.last) {
      _sequenceController.add(SequenceStatus.wrong);
      recognizedGestures.clear();
    } else {
      _sequenceController.add(SequenceStatus.correct);
      points += 10;
    }
  }

  void cacheCurrentSequence(List<HandGesutre> sequence) {
    currentSequence = sequence;
  }

  void addRecognizedGesture(HandGesutre gesture) {
    recognizedGestures.add(gesture);
    _gameController.add(gesture);
  }

  void dispose() {
    _gameController.close();
  }

  void resetGame() {
    recognizedGestures.clear();
    points = 0;
    currentSequence.clear();
    _sequenceController.add(SequenceStatus.complete);
  }
}

enum SequenceStatus { correct, wrong, incomplete, complete }
