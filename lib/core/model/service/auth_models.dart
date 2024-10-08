import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simon_ai/core/model/player.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class SignInResponse with _$SignInResponse {
  @JsonSerializable()
  factory SignInResponse({
    required String accessToken,
    required Player user,
  }) = _SignInResponse;

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);
}

@freezed
class SignInRequest with _$SignInRequest {
  @JsonSerializable()
  factory SignInRequest({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'username') String? username,
  }) = _SignInRequest;

  factory SignInRequest.fromJson(Map<String, dynamic> json) =>
      _$SignInRequestFromJson(json);
}
