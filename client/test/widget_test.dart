// ignore_for_file: cascade_invocations

import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';

import 'mocks/mocks.dart';

void main() {
  test('Game correct sequence simulation test. ', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final gameHandler = GameManager(MockGestureProcessorPool())..init();
    final gameGestures = [
      HandGesture.love,
      HandGesture.victory,
      HandGesture.pointingUp,
    ];
    final List<GameResponse> gameResponses = [];
    gameHandler
        .startSequence(gameGestures)
        .listen((event) => gameResponses.add(event));

    final gestures = gameGestures.map(
      (gesture) => _gestureToHandGestureWithPosition(gesture),
    );

    gestures.forEach(gameHandler.addGesture);

    // Wait for the game to finish
    await Future.delayed(const Duration(milliseconds: 10));
    expect(
      gameResponses.map((e) => e.gesture).toList(),
      gestures,
    );
    expect(
      gameResponses.map((e) => e.isCorrect).all((isCorrect) => isCorrect),
      true,
    );
    expect(gameResponses.last.finishSequence, true);
  });

  test('Game with error sequence simulation test. ', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final gameHandler = GameManager(MockGestureProcessorPool())..init();
    final gameGestures = [
      HandGesture.love,
      HandGesture.victory,
      HandGesture.pointingUp,
    ];
    final List<GameResponse> gameResponses = [];
    gameHandler
        .startSequence(gameGestures)
        .listen((event) => gameResponses.add(event));

    final recognizedGestures = [
      HandGesture.love,
      HandGesture.victory,
      HandGesture.love,
    ].map((gesture) => _gestureToHandGestureWithPosition(gesture));

    recognizedGestures.forEach(gameHandler.addGesture);

    // Wait for the game to finish
    await Future.delayed(const Duration(milliseconds: 10));
    expect(
      gameResponses.map((GameResponse e) => e.gesture).toList(),
      recognizedGestures,
    );
    expect(
      gameResponses.map((e) => e.isCorrect).map((isCorrect) => isCorrect),
      [true, true, false],
    );
    expect(gameResponses.last.finishSequence, true);
  });
}

HandGestureWithPosition _gestureToHandGestureWithPosition(
  HandGesture gesture,
) =>
    (
      boundingBox: (confidence: 0.0, h: 0.0, w: 0.0, x: 0.0, y: 0.0),
      gesture: gesture,
      gesturePosition: (x: 0.0, y: 0.0)
    );
