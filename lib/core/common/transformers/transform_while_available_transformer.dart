import 'dart:async';
import 'dart:collection';

import 'package:mutex/mutex.dart';

typedef Processor<T, R> = FutureOr<R> Function(T);

class ProcessWhileAvailableTransformer<T, R>
    extends StreamTransformerBase<T, R> {
  var _isClosed = false;
  final List<Processor> _availableProcessors;
  final Set<Processor> _processors;

  final _mutex = Mutex();
  final Queue<T> _unprocessedQueue = Queue<T>();

  ProcessWhileAvailableTransformer(Iterable<Processor> processors)
      : _processors = processors.toSet(),
        _availableProcessors = processors.toList();

  Future<void> _processValue(
    Processor processor,
    T value,
    EventSink<R> sink,
  ) async {
    try {
      T? currentValue = value;
      do {
        final event = await processor(currentValue);
        sink.add(event);
        // ignore: avoid-redundant-async
        await _mutex.protect(() async {
          currentValue = _unprocessedQueue.isEmpty
              ? null
              : _unprocessedQueue.removeFirst();
        });
      } while (currentValue != null && !_isClosed);
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
        _unprocessedQueue.addLast(value);
        if (_unprocessedQueue.length > _processors.length) {
          // Drop the oldest value when the queue is full
          _unprocessedQueue.removeFirst();
        }
      } else {
        final processor = _availableProcessors.removeAt(0);
        unawaited(
          _processValue(processor, value, sink).then(
            (_) => _mutex.protect(
              () async => _availableProcessors.add(processor),
            ),
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
