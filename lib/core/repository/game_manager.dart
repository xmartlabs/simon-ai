import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/common/transformers/game_gesture_stabilization_transformer.dart';
import 'package:simon_ai/core/common/transformers/game_sequence_logic_transformer.dart';
import 'package:simon_ai/core/common/transformers/transform_while_available_transformer.dart';
import 'package:simon_ai/core/hand_models/keypoints/gesture_processor.dart';
import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GameManager {
  final GestureProcessorPool _gestureProcessorPool;

  bool _initializedFirstFrame = false;

  Timer? _fpsTimer;
  late StreamController<int> _fpsStreamController;

  Stream<int> get fps => _fpsStreamController.stream;

  Stream<HandGestureWithPosition> get gameSequenceStream =>
      _gameSequenceController.stream
          .distinct((previous, next) => previous.gesture == next.gesture)
          .asBroadcastStream();

  Stream<dynamic> get gestureStream => _gestureStreamController.stream;

  late StreamController<dynamic> _gestureStreamController;
  late StreamController<dynamic> _processNewFrameController;
  late StreamController<HandGestureWithPosition> _gameSequenceController;

  GameManager(this._gestureProcessorPool);

  void init() {
    _gameSequenceController =
        StreamController<HandGestureWithPosition>.broadcast();
    _gestureStreamController = StreamController<dynamic>.broadcast();
    _processNewFrameController = StreamController<dynamic>.broadcast();
    unawaited(_initializeStream());
    WakelockPlus.enable().ignore();
  }

  Future<void> _initializeStream() async {
    await _gestureProcessorPool.init();
    _fpsStreamController = StreamController<int>.broadcast();
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final fps = _gestureProcessorPool.fps;
      _fpsStreamController.add(fps);
      Logger.i('FPS: $fps, -> '
          '${_gestureProcessorPool.processors.map((it) => it.fps).join(',')}');
    });

    _processNewFrameController.stream
        .transform(
          ProcessWhileAvailableTransformer<dynamic, HandGestureWithPosition>(
            _gestureProcessorPool.processors.map(
              (processor) => (frame) => _processNewFrame(processor, frame),
            ),
          ),
        )
        .transform(GameGestureStabilizationTransformer())
        .listen(addGesture);
  }

  void processFrame(dynamic frame) {
    _processNewFrameController.add(frame);
  }

  Future<HandGestureWithPosition> _processNewFrame(
    GestureProcessor processor,
    dynamic newFrame,
  ) async {
    // Wait the transition time
    if (!_initializedFirstFrame) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _initializedFirstFrame = true;
    }

    final result = await processor.processFrame(newFrame);
    _gestureStreamController.add(result);
    return (
      gesture: result.gesture,
      gestureConfidence: result.gestureConfidence,
      gesturePosition: result.keyPoints.centerCoordinates,
      boundingBox: result.cropData,
    );
  }

  @visibleForTesting
  void addGesture(HandGestureWithPosition gesture) {
    _gameSequenceController.add(gesture);
  }

  Future<void> close() async {
    await _processNewFrameController.close();
    await _gestureProcessorPool.close();

    await _gestureStreamController.close();
    _fpsTimer?.cancel();
    await _fpsStreamController.close();
    restartStream();
    await WakelockPlus.disable();
  }

  void restartStream() {
    _gameSequenceController.close();
    _gameSequenceController =
        StreamController<HandGestureWithPosition>.broadcast();
  }

  Stream<GameResponse> startSequence(List<HandGesture> gameSequence) {
    restartStream();
    return gameSequenceStream
        .transform(GameSequenceLogicTransformer(gameSequence));
  }
}
