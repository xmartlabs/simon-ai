part of 'admin_area_cubit.dart';

@freezed
class AdminAreaState with _$AdminAreaState {
  const factory AdminAreaState.state({
    String? currentUserEmail,
    String? email,
    String? password,
    String? error,
  }) = _AdminAreaState;
}

extension AdminareaExtension on AdminAreaState {
  bool get isFormValid =>
      email != null &&
      email!.isNotEmpty &&
      password != null &&
      password!.isNotEmpty;
}
