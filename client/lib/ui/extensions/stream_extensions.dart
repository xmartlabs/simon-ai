import 'dart:async';

extension StreamExtensions<T> on Stream<T> {
  Stream<R> discardWhileProcessing<R>(FutureOr<R> Function(T) asyncMapper) {
    var isProcessing = false;
    T? lastUnprocessedValue;

    return transform(
      StreamTransformer<T, R>.fromHandlers(
        handleData: (T value, EventSink<R> sink) async {
          if (!isProcessing) {
            isProcessing = true;
            sink.add(await asyncMapper(value));
            T? lastValue;
            while (lastUnprocessedValue != null) {
              lastValue = lastUnprocessedValue;
              lastUnprocessedValue = null;
              sink.add(await asyncMapper(lastValue as T));
            }
            isProcessing = false;
          } else {
            lastUnprocessedValue = value;
          }
        },
        handleError: (Object error, StackTrace stackTrace, EventSink<R> sink) {
          sink.addError(error, stackTrace);
        },
        handleDone: (EventSink<R> sink) {
          sink.close();
        },
      ),
    );
  }
}
