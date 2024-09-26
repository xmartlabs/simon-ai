import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/ui/onboarding/register/register_player_section_cubit.dart';

part 'register_player_name_cubit.freezed.dart';
part 'register_player_name_state.dart';

class RegisterPlayerNameCubit extends Cubit<RegisterPlayerNameState> {
  final RegisterPlayerHandler _registerPlayerHandler;

  RegisterPlayerNameCubit(this._registerPlayerHandler)
      : super(const RegisterPlayerNameState.initial(username: '')) {
    _registerPlayerHandler.getSuggestedName().then((name) {
      if (name != null) {
        changeUsername(name);
      }
    });
  }

  void changeUsername(String username) => emit(
        state.copyWith(username: username),
      );

  Future<void> registerPlayer() =>
      _registerPlayerHandler.setName(state.username);
}
