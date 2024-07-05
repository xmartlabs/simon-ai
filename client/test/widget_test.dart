import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/repository/game_repository.dart';

void main() {
  test('Example test', () async {
    final gameRepository = GameRepository();

    gameRepository.startGame([
      HandGesutre.A,
      HandGesutre.B,
      HandGesutre.C,
    ]);

    final game = await gameRepository.startGame([
      HandGesutre.A,
      HandGesutre.B,
      HandGesutre.C,
    ]).scan((accumulated, value, index) => [...accumulated, value], []).last;
    final list = game.map((e) => e.gesture).toList();
    print(list);
    expect(list, [
      HandGesutre.A,
      HandGesutre.A,
      HandGesutre.B,
      HandGesutre.A,
      HandGesutre.B,
      HandGesutre.C,
    ]);
  });
}
