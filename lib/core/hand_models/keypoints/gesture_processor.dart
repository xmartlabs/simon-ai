import 'package:dartx/dartx.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';

abstract interface class GestureProcessor {
  int get fps;

  Future<HandLandmarksData> processFrame(dynamic newFrame);

  Future<void> close();

  Future<void> init();
}

class GestureProcessorPool {
  final List<GestureProcessor> processors;

  int get fps => processors.sumBy((processor) => processor.fps);

  GestureProcessorPool(List<GestureProcessor> processors)
      : processors = List.unmodifiable(processors);

  Future<void> init() => Stream.fromIterable(processors)
      .asyncMap((processor) => processor.init())
      .toList();

  Future<void> close() => Stream.fromIterable(processors)
      .asyncMap((processor) => processor.close())
      .toList();
}
