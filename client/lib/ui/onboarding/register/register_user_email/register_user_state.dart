part of 'register_user_cubit.dart';

@freezed
class RegisterUserBaseState with _$RegisterUserBaseState {
  const factory RegisterUserBaseState.state({
    required String? email,
    required String? nickname,
    String? error,
  }) = RegisterUserState;
}

extension RegisterUserBaseStateExtension on RegisterUserBaseState {
  bool get isFormValid =>
      email != null && email!.isNotEmpty && email!.isValidEmail;
}
