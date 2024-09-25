import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:simon_ai/core/common/logger.dart';
import 'package:simon_ai/core/model/hand_gesture_with_position.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';

const _logEnabled = true;
const _logVerbose = true;

/// Transforms a stream of [HandGestureWithPosition] into a stream of game
/// [HandGestureWithPosition].
/// If the stream of gestures is consistent for a certain amount of time,
/// the transformer will emit the gesture.
class GameGestureStabilizationTransformer extends StreamTransformerBase<
    HandGestureWithPosition, HandGestureWithPosition> {
  @override
  Stream<HandGestureWithPosition> bind(
    Stream<HandGestureWithPosition> stream,
  ) =>
      stream
          .transform(
            _StabilizationBufferWithTimeOrCount(
              maxUnrecognizedGesturesInWindow: Platform.isAndroid ? 5 : 2,
              minWindowSize: Platform.isAndroid ? 3 : 5,
              timeSpan: Platform.isAndroid
                  ? const Duration(milliseconds: 500)
                  : const Duration(seconds: 1),
              windowSize: 5,
            ),
          )
          .asyncMap((bufferedGestures) => bufferedGestures.lastOrNull)
          .whereNotNull()
          .distinct((previous, next) => previous.gesture == next.gesture)
          .asBroadcastStream();
}

class _StabilizationBufferWithTimeOrCount extends StreamTransformerBase<
    HandGestureWithPosition, List<HandGestureWithPosition>> {
  final int windowSize;
  final int minWindowSize;
  final int maxUnrecognizedGesturesInWindow;
  final Duration timeSpan;

  late StreamSubscription<HandGestureWithPosition> _subscription;
  late StreamController<List<HandGestureWithPosition>> _controller;

  final List<HandGestureWithPosition> _buffer = [];
  Timer? _timer;
  final _windowTime = Stopwatch();
  var _requireEmmit = false;
  var _currentUnrecognizedGestures = 0;

  _StabilizationBufferWithTimeOrCount({
    required this.maxUnrecognizedGesturesInWindow,
    required this.minWindowSize,
    required this.timeSpan,
    required this.windowSize,
  });

  void _resetBuffer() {
    _buffer.clear();
    _timer?.cancel();
    _timer = null;
    _windowTime.reset();
    _currentUnrecognizedGestures = 0;
  }

  void _emitBuffer() {
    if (_buffer.isNotEmpty) {
      if (_buffer.length >= minWindowSize) {
        _requireEmmit = false;
        _controller.add(List.unmodifiable(_buffer));
        if (_logEnabled) {
          Logger.i(
            "Emit gesture ${_buffer.first.gesture}, "
            "bufferSize: ${_buffer.length}, "
            "time: ${_windowTime.elapsedMilliseconds} millis",
          );
        }
      } else {
        _requireEmmit = true;
      }
    }
    if (!_requireEmmit) {
      _resetBuffer();
    }
  }

  void _handleNewGesture(HandGestureWithPosition gestureWithPosition) {
    if (gestureWithPosition.gesture == HandGesture.unrecognized) {
      _currentUnrecognizedGestures++;
      if (_currentUnrecognizedGestures >= maxUnrecognizedGesturesInWindow) {
        _resetBuffer();
        if (_logVerbose) {
          Logger.i("Max unrecognized gestures reached, reset window");
        }
      } else if (_logVerbose) {
        Logger.i("Discard unrecognized gesture");
      }
      return;
    }
    if (_buffer.isEmpty) {
      _windowTime.reset();
    }

    _buffer.add(gestureWithPosition);
    _timer ??= Timer(timeSpan, _emitBuffer);

    final firstGesture = _buffer.first;
    final isConsistent =
        _buffer.every((gesture) => gesture.gesture == firstGesture.gesture);
    if (!isConsistent) {
      if (_logVerbose) {
        Logger.i("Discard gesture ${firstGesture.gesture}");
      }
      _resetBuffer();
    }

    if (_buffer.length >= windowSize || _requireEmmit) {
      _emitBuffer();
    }
  }

  @override
  Stream<List<HandGestureWithPosition>> bind(
    Stream<HandGestureWithPosition> stream,
  ) {
    _controller = StreamController<List<HandGestureWithPosition>>(
      onCancel: () => _subscription.cancel(),
      onResume: () => _subscription.resume(),
      onPause: () => _subscription.pause(),
    );
    _windowTime.start();

    _subscription = stream.listen(
      _handleNewGesture,
      onError: _controller.addError,
      onDone: () {
        _emitBuffer();
        _controller.close();
      },
      cancelOnError: false,
    );

    return _controller.stream;
  }
}
