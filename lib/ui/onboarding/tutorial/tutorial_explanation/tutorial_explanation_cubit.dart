import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';
import 'package:simon_ai/ui/router/app_router.dart';

part 'tutorial_explanation_cubit.freezed.dart';
part 'tutorial_explanation_state.dart';

class TutorialExplanationCubit extends Cubit<TutorialExplanationState> {
  final PermissionHandlerInterface _permissionHandler = DiProvider.get();
  final AppRouter _appRouter = DiProvider.get();

  TutorialExplanationCubit()
      : super(
          const TutorialExplanationState.initial(
            step: OnboardingSteps.initial,
          ),
        ) {
    unawaited(checkCameraPermission());
  }

  Future<void> checkCameraPermission() async {
    emit(
      state.copyWith(
        hasCameraPermission: await _permissionHandler.hasCameraPermisssion(),
      ),
    );
  }

  void navigateToGame() => unawaited(_appRouter.navigate(const GameRoute()));

  Future<void> requestCameraPermission() async {
    final gotPermission = await _permissionHandler.requestCameraPermission();
    if (gotPermission != null && gotPermission) {
      navigateToGame();
    }
  }
}
