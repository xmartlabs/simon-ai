import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/ui/extensions/stream_extensions.dart';

class GameManager {
  final GestureProcessor _gestureProcessor;

  int _points = 0;

  final _pointForSuccess = 5;
  final _gestureDetectionTime = const Duration(milliseconds: 400);

  bool _initializedFirstFrame = false;

  Stream<int> get fps => _gestureProcessor.fps;
  Stream<dynamic> get gestureStream => _gestureStreamController.stream;
  late Stream<dynamic> _newFrameStream;

  late StreamController<dynamic> _gestureStreamController;
  late StreamController<dynamic> _processNewFrameController;
  late StreamController<HandGestureWithPosition> _gameSequenceController;

  GameManager(this._gestureProcessor);

  Future<void> init() async {
    _gameSequenceController =
        StreamController<HandGestureWithPosition>.broadcast();
    _gestureStreamController = StreamController<dynamic>.broadcast();
    _processNewFrameController = StreamController<dynamic>.broadcast();
    unawaited(_initializeStream());
  }

  Future<void> _initializeStream() async {
    await _gestureProcessor.init();
    _newFrameStream = _processNewFrameController.stream;
    _newFrameStream.processWhileAvailable(_processNewFrame).listen((event) {
      // TODO add implementation for after-processing frame
    });
  }

  void processFrame(dynamic frame) {
    _processNewFrameController.add(frame);
  }

  Future<void> _processNewFrame(dynamic newFrame) async {
    // Wait the transition time
    if (!_initializedFirstFrame) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _initializedFirstFrame = true;
    }

    final result = await _gestureProcessor.processFrame(newFrame);
    _gestureStreamController.add(result);
    addGesture(
      (
        gesture: result.gesture,
        gesturePosition: result.keyPoints.centerCoordinates,
        boundingBox: result.cropData,
      ),
    );
  }

  @visibleForTesting
  void addGesture(HandGestureWithPosition gesture) {
    _gameSequenceController.add(gesture);
  }

  Future<void> close() async {
    await _processNewFrameController.close();
    await _gestureProcessor.close();
    await _gestureStreamController.close();
    restartStream();
    resetPoints();
  }

  void resetPoints() {
    _points = 0;
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
