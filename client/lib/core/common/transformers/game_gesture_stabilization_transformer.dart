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
  static final _defaultTimeSpan = Platform.isAndroid
      ? const Duration(seconds: 1)
      : const Duration(milliseconds: 500);
  static const _defaultWindowSize = 7;
  static final _defaultMinWindowSize = Platform.isAndroid ? 3 : 5;
  static final _defaultMaxUnrecognizedGesturesInWindow =
      Platform.isAndroid ? 2 : 3;

  final int _windowSize;
  final int _minWindowSize;
  final int _maxUnrecognizedGesturesInWindow;
  final Duration _timeSpan;

  late StreamSubscription<HandGestureWithPosition> _subscription;
  late StreamController<List<HandGestureWithPosition>> _controller;

  final List<HandGestureWithPosition> _buffer = [];
  Timer? _timer;
  final _windowTime = Stopwatch();
  var _requireEmmit = false;
  var _currentUnrecognizedGestures = 0;

  GameGestureStabilizationTransformer({
    int? maxUnrecognizedGesturesInWindow,
    int? minWindowSize,
    Duration? timeSpan,
    int? windowSize,
  })  : _timeSpan = timeSpan ?? _defaultTimeSpan,
        _windowSize = windowSize = _defaultWindowSize,
        _minWindowSize = minWindowSize ?? _defaultMinWindowSize,
        _maxUnrecognizedGesturesInWindow = maxUnrecognizedGesturesInWindow ??
            _defaultMaxUnrecognizedGesturesInWindow;

  void _resetBuffer() {
    _buffer.clear();
    _timer?.cancel();
    _timer = null;
    _windowTime.reset();
    _currentUnrecognizedGestures = 0;
  }

  void _emitBuffer() {
    if (_buffer.isNotEmpty) {
      if (_buffer.length >= _minWindowSize) {
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
      if (_currentUnrecognizedGestures >= _maxUnrecognizedGesturesInWindow) {
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
    _timer ??= Timer(_timeSpan, _emitBuffer);

    final firstGesture = _buffer.first;
    final isConsistent =
        _buffer.every((gesture) => gesture.gesture == firstGesture.gesture);
    if (!isConsistent) {
      if (_logVerbose) {
        Logger.i("Discard gesture ${firstGesture.gesture}");
      }
      _resetBuffer();
    }

    if (_buffer.length >= _windowSize || _requireEmmit) {
      _emitBuffer();
    }
  }

  @override
  Stream<HandGestureWithPosition> bind(Stream<HandGestureWithPosition> stream) {
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

    return _controller.stream
        .map((bufferedGestures) => bufferedGestures.lastOrNull)
        .whereNotNull();
  }
}
