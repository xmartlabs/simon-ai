part of 'register_player_email_cubit.dart';

@freezed
class RegisterPlayerEmailBaseState with _$RegisterPlayerEmailBaseState {
  const factory RegisterPlayerEmailBaseState.state({
    required String? email,
  }) = RegisterPlayerEmailState;
}

extension RegisterPlayerEmailBaseStateExtension
    on RegisterPlayerEmailBaseState {
  bool get isFormValid =>
      email != null && email!.isNotEmpty && email!.isValidEmail;
}
