import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';

void main() {
  test(
      'Game correct sequence simulation test. '
      'Input: love, victory, pointingUp. Output: love, love, victory, love, victory, pointingUp',
      () async {
    final gameHandler = GameManager()
      ..startGame([
        HandGesture.love,
        HandGesture.victory,
        HandGesture.pointingUp,
      ]);

    final game = await gameHandler.startGame([
      HandGesture.love,
      HandGesture.victory,
      HandGesture.pointingUp,
    ]).scan((accumulated, value, index) => [...accumulated, value], []).last;
    final list = game.map((e) => e.gesture).toList();
    expect(list, [
      HandGesture.love,
      HandGesture.love,
      HandGesture.victory,
      HandGesture.love,
      HandGesture.victory,
      HandGesture.pointingUp,
    ]);
  });
}
