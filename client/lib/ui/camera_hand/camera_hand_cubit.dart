import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager.dart';
import 'package:simon_ai/core/manager/keypoints/keypoints_manager_mobile.dart';
import 'package:simon_ai/ui/extensions/stream_extensions.dart';

part 'camera_hand_state.dart';

part 'camera_hand_cubit.freezed.dart';

class CameraHandCubit extends Cubit<CameraHandState> {
  final KeyPointsManager _keyPointsManager = DiProvider.get();
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
