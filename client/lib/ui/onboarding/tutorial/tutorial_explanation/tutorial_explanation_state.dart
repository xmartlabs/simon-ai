part of 'tutorial_explanation_cubit.dart';

@freezed
class TutorialExplanationState with _$TutorialExplanationState {
  const factory TutorialExplanationState.initial({
    required OnboardingSteps step,
  }) = _Initial;
}

enum OnboardingSteps { initial, hands, permissions }
