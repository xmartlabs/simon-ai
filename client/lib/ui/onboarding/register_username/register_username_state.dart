part of 'register_username_cubit.dart';

@freezed
class RegisterUsernameState with _$RegisterUsernameState {
  const factory RegisterUsernameState.initial({
    required String username,
  }) = _Initial;
}
