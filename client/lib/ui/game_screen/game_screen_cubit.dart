import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_screen_cubit.freezed.dart';
part 'game_screen_state.dart';

class GameScreenCubit extends Cubit<GameScreenState> {
  GameScreenCubit()
      : super(
          const GameScreenState.initial(
            currentPoints: 0,
          ),
        );
}
