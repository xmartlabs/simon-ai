import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_example_cubit.freezed.dart';
part 'tutorial_example_state.dart';

class TutorialExampleCubit extends Cubit<TutorialExampleState> {
  TutorialExampleCubit() : super(const TutorialExampleState.initial());
}
