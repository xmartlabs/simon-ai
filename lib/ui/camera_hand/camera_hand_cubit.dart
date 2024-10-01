import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/repository/game_manager.dart';

part 'camera_hand_cubit.freezed.dart';
part 'camera_hand_state.dart';

class CameraHandCubit extends Cubit<CameraHandState> {
  final GameManager _gameHandler = DiProvider.get();

  CameraHandCubit() : super(const CameraHandState.state()) {
    _gameHandler.init();
    emit(CameraHandState.state(gestureStream: _gameHandler.gestureStream));
  }

  @override
  Future<void> close() async {
    await _gameHandler.close();
    await super.close();
  }

  void onNewFrame(dynamic frame) => _gameHandler.processFrame(frame);
}
