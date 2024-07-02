import 'dart:async';

extension StreamExtensions<T> on Stream<T> {
  Stream<R> discardWhileProcessing<R>(FutureOr<R> Function(T) asyncMapper) {
    T? lastUnprocessedValue;
    var isProcessing = false;
    // Define a separate async function to process the value.
    Future<void> processValue(T value, EventSink<R> sink) async {
      sink.add(await asyncMapper(value));
      T? lastValue;
      while (lastUnprocessedValue != null) {
        lastValue = lastUnprocessedValue;
        lastUnprocessedValue = null;
        sink.add(await asyncMapper(lastValue as T));
      }
    }

    return transform(
      StreamTransformer<T, R>.fromHandlers(
        handleData: (T value, EventSink<R> sink) {
          if (!isProcessing) {
            isProcessing = true;
            // Execute async work in a separate function.
            processValue(value, sink).then((_) => isProcessing = false);
          } else {
            lastUnprocessedValue = value;
          }
        },
        handleError: (Object error, StackTrace stackTrace, EventSink<R> sink) =>
            sink.addError(error, stackTrace),
        handleDone: (EventSink<R> sink) => sink.close(),
      ),
    );
  }
}
