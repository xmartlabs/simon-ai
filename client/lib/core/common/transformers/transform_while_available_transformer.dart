import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:mutex/mutex.dart';

typedef Processor<T, R> = FutureOr<R> Function(T);

class ProcessWhileAvailableTransformer<T, R>
    extends StreamTransformerBase<T, R> {
  var _isClosed = false;
  final List<Processor> _availableProcessors;
  final Set<Processor> _processors;

  final _mutex = Mutex();
  final List<T?> _unprocessedValues = [];

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
        sink.add(await processor(value));
        // ignore: avoid-redundant-async
        await _mutex.protect(() async {
          currentValue = _unprocessedValues.firstOrNull;
          if (currentValue != null) {
            _unprocessedValues.removeAt(0);
          }
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
        _unprocessedValues.add(value);
        _availableProcessors.takeLast(_processors.length);
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
