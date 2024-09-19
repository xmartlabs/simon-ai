import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

/// Transforms a stream of [HandGestureWithPosition] into a stream of game
/// [HandGestureWithPosition].
/// If the stream of gestures is consistent for a certain amount of time,
/// the transformer will emit the gesture.
class GameGestureStabilizationTransformer extends StreamTransformerBase<
    HandGestureWithPosition, HandGestureWithPosition> {
  final _gestureDetectionTime = const Duration(milliseconds: 400);

  @override
  Stream<HandGestureWithPosition> bind(
    Stream<HandGestureWithPosition> stream,
  ) =>
      stream
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
}
