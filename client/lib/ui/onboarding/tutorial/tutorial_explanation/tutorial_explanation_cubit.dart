import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/di/di_provider.dart';
import 'package:simon_ai/core/interfaces/permission_handler_interface.dart';

part 'tutorial_explanation_cubit.freezed.dart';
part 'tutorial_explanation_state.dart';

class TutorialExplanationCubit extends Cubit<TutorialExplanationState> {
  final PermissionHandlerInterface _permissionHandler = DiProvider.get();

  TutorialExplanationCubit()
      : super(
          const TutorialExplanationState.initial(
            step: OnboardingSteps.initial,
            hasCameraPermission: false,
          ),
        );

  void incrementSteps() {
    final currentStep = state.step;
    final nextStep = OnboardingSteps.values[currentStep.index + 1];
    emit(state.copyWith(step: nextStep));
  }

  Future<void> requestCameraPermission() async {
    final gotPermission = await _permissionHandler.requestCameraPermission();

    if (gotPermission != null) {
      emit(state.copyWith(hasCameraPermission: gotPermission));
    }
  }
}
