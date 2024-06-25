part of 'register_user_cubit.dart';

@freezed
class RegisterUserBaseState with _$RegisterUserBaseState {
  const factory RegisterUserBaseState.state({
    required String? email,
    required String? nickname,
    required String error,
  }) = RegisterUserState;
}
