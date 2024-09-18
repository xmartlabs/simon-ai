import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:simon_ai/core/common/transformers/game_gesture_stabilization_transformer.dart';
import 'package:simon_ai/core/common/transformers/game_logic_transformer.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/ui/extensions/stream_extensions.dart';

class GameManager {
  final GestureProcessor _gestureProcessor;

  bool _initializedFirstFrame = false;

  Stream<int> get fps => _gestureProcessor.fps;

  Stream<HandGestureWithPosition> get gameSequenceStream =>
      _gameSequenceController.stream
          .transform(GameGestureStabilizationTransformer());

  Stream<dynamic> get gestureStream => _gestureStreamController.stream;
  late Stream<dynamic> _newFrameStream;

  late StreamController<dynamic> _gestureStreamController;
  late StreamController<dynamic> _processNewFrameController;
  late StreamController<HandGestureWithPosition> _gameSequenceController;

  GameManager(this._gestureProcessor);

  void init() {
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
  }

  void restartStream() {
    _gameSequenceController.close();
    _gameSequenceController =
        StreamController<HandGestureWithPosition>.broadcast();
  }

  Stream<GameResponse> startSequence(List<HandGesture> gameSequence) {
    restartStream();
    return gameSequenceStream.transform(GameLogicTransformer(gameSequence));
  }
}
