import 'package:simon_ai/core/model/hand_gestures.dart';

typedef GameResponse = ({
  HandGesture gesture,
  int points,
  bool finishSequence,
  bool isCorrect,
});
