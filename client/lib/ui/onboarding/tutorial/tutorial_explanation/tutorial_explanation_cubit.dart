import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_explanation_cubit.freezed.dart';
part 'tutorial_explanation_state.dart';

class TutorialExplanationCubit extends Cubit<TutorialExplanationState> {
  TutorialExplanationCubit()
      : super(
          const TutorialExplanationState.initial(
            step: Steps.initial,
          ),
        );
}
