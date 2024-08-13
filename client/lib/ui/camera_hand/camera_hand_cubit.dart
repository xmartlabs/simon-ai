import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/hand_models/keypoints/keypoints_manager.dart';
import 'package:simon_ai/core/model/coordinates.dart';
import 'package:simon_ai/core/model/hand_gestures.dart';
import 'package:simon_ai/core/model/hand_landmarks_result_data.dart';
import 'package:simon_ai/core/repository/game_manager.dart';
import 'package:simon_ai/ui/extensions/stream_extensions.dart';

part 'camera_hand_cubit.freezed.dart';
part 'camera_hand_state.dart';

class CameraHandCubit extends Cubit<CameraHandState> {
  final KeyPointsManager _keyPointsManager = DiProvider.get();
  final GameManager _gameHandler = DiProvider.get();
  bool _initializedFirstFrame = false;
  final StreamController<dynamic> _movementStreamController =
      StreamController<dynamic>.broadcast();
  late Stream<dynamic> _movenetStream;
  late Stream<dynamic> _newFrameStream;
  final _frameController = StreamController<dynamic>.broadcast();

  CameraHandCubit() : super(const CameraHandState.state()) {
    _movenetStream = _movementStreamController.stream;

    unawaited(_initializeStream());
  }

  void onNewFrame(dynamic frame) {
    _frameController.add(frame);
  }

  Future<void> _processNewFrame(dynamic newFrame) async {
    // Wait the transition time
    if (!_initializedFirstFrame) {
      await Future.delayed(const Duration(milliseconds: 1000));
      _initializedFirstFrame = true;
    }

    final result = await _keyPointsManager.processFrame(newFrame);
    _movementStreamController.add(result);
    _gameHandler.addGesture(
      (
        gesture: result.gesture,
        gesturePosition: calculateCenter(result.keyPoints),
        box: result.cropData,
      ),
    );
  }

  Future<void> _initializeStream() async {
    await _keyPointsManager.init();
    _newFrameStream = _frameController.stream;
    emit(state.copyWith(movenetResultStream: _movenetStream));
    // ignore: no-empty-block
    _newFrameStream.discardWhileProcessing(_processNewFrame).listen((event) {
      // TODO add implementation for after-processing frame
    });
  }
}

Coordinates calculateCenter(
  List<({double x, double y, double z})> coordinates,
) {
  if (coordinates.isEmpty) {
    throw ArgumentError('The coordinates list cannot be empty');
  }

  double sumX = 0;
  double sumY = 0;

  for (final coordinate in coordinates) {
    sumX += coordinate.x;
    sumY += coordinate.y;
  }

  final double centerX = sumX / coordinates.length;
  final double centerY = sumY / coordinates.length;

  return (x: centerX, y: centerY); // z is set to 0 as it's not needed
}
