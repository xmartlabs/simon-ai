part of 'register_player_name_cubit.dart';

@freezed
class RegisterPlayerNameState with _$RegisterPlayerNameState {
  const factory RegisterPlayerNameState.initial({
    required String username,
  }) = _Initial;
}
