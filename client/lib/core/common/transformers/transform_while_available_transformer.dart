import 'dart:async';

import 'package:mutex/mutex.dart';

typedef Processor<T, R> = FutureOr<R> Function(T);

class ProcessWhileAvailableTransformer<T, R>
    extends StreamTransformerBase<T, R> {
  T? _lastUnprocessedValue;
  var _isClosed = false;
  final Set<Processor> _availableProcessors;

  final _mutex = Mutex();

  ProcessWhileAvailableTransformer(Iterable<Processor> processors)
      : _availableProcessors = processors.toSet();

  Future<void> _processValue(
    Processor processor,
    T value,
    EventSink<R> sink,
  ) async {
    try {
      sink.add(await processor(value));
      T? lastValue;
      do {
        // ignore: avoid-redundant-async
        await _mutex.protect(() async {
          lastValue = _lastUnprocessedValue;
          _lastUnprocessedValue = null;
        });
        if (lastValue != null && !_isClosed) {
          sink.add(await processor(value));
        }
      } while (lastValue != null && !_isClosed);
    } catch (e) {
      if (!_isClosed) {
        sink.addError(e);
      }
    }
  }

  void _handleData(T value, EventSink<R> sink) {
    // ignore: avoid-redundant-async
    _mutex.protect(() async {
      if (_availableProcessors.isEmpty) {
        _lastUnprocessedValue = value;
      } else {
        final processor = _availableProcessors.first;
        _availableProcessors.remove(processor);
        unawaited(
          _processValue(processor, value, sink).then(
            (_) =>
                _mutex.protect(() async => _availableProcessors.add(processor)),
          ),
        );
      }
    });
  }

  @override
  Stream<R> bind(Stream<T> stream) => stream.transform(
        StreamTransformer<T, R>.fromHandlers(
          handleData: _handleData,
          handleError:
              (Object error, StackTrace stackTrace, EventSink<R> sink) {
            sink.addError(error, stackTrace);
          },
          handleDone: (EventSink<R> sink) {
            sink.close();
            _isClosed = true;
          },
        ),
      );
}
