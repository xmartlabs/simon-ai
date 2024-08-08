import 'package:dartx/dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simon_ai/core/model/game_response.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_manager.dart';

import 'test_helpers.dart';

void main() {
  test(
      'Game correct sequence simulation test. '
      // ignore: lines_longer_than_80_chars
      'Input: love, victory, pointingUp. Output: love, love, victory, love, victory, pointingUp',
      () async {
    final gameHandler = GameManager();
    final game = gameHandler.startGame([
      HandGesture.love,
      HandGesture.victory,
      HandGesture.pointingUp,
    ]);
    final List<GameResponse> gameResponses = [];
    game.listen((event) {
      gameResponses.add(event);
    });
    await executeForDuration(const Duration(milliseconds: 600), () {
      gameHandler.addGesture(HandGesture.love);
    });
    await executeForDuration(const Duration(milliseconds: 600), () {
      gameHandler.addGesture(HandGesture.victory);
    });
    await executeForDuration(const Duration(milliseconds: 600), () {
      gameHandler.addGesture(HandGesture.pointingUp);
    });
    expect(
      gameResponses.map((e) => e.gesture).toList(),
      [
        HandGesture.love,
        HandGesture.victory,
        HandGesture.pointingUp,
      ],
    );
    expect(
      gameResponses
          .map((e) => e.isCorrect)
          .all((isCorrect) => isCorrect),
      true,
    );
    expect(gameResponses.last.finishSequence, true);
  });
}
