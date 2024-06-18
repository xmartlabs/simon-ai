part of 'tutorial_explanation_cubit.dart';

@freezed
class TutorialExplanationState with _$TutorialExplanationState {
  const factory TutorialExplanationState.initial({
    required Steps step,
  }) = _Initial;
}

enum Steps { initial, hands, permissions }