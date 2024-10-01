import 'package:simon_ai/core/model/hand_gesture_with_position.dart';

typedef GameResponse = ({
  HandGestureWithPosition gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
