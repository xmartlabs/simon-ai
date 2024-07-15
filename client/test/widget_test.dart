import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_handler.dart';

void main() {
  test(
      'Game correct sequence simulation test. '
      'Input: A, B, C. Output: A, A, B, A, B, C ', () async {
    final gameHandler = GameHandler()
      ..startGame([
        HandGesture.A,
        HandGesture.B,
        HandGesture.C,
      ]);

    final game = await gameHandler.startGame([
      HandGesture.A,
      HandGesture.B,
      HandGesture.C,
    ]).scan((accumulated, value, index) => [...accumulated, value], []).last;
    final list = game.map((e) => e.gesture).toList();
    expect(list, [
      HandGesture.A,
      HandGesture.A,
      HandGesture.B,
      HandGesture.A,
      HandGesture.B,
      HandGesture.C,
    ]);
  });
}
