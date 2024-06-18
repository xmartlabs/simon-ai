import 'package:simon_ai/core/model/service/auth_models.dart';
import 'package:simon_ai/core/model/service/service_response.dart';
import 'package:simon_ai/core/source/common/http_service.dart';

class AuthRemoteSource {
  final HttpServiceDio _httpService;

  static const _urlLogin = 'auth/v1/token';

  AuthRemoteSource(this._httpService);

  Future<SignInResponse> signIn(String email, String? username) async =>
      (await _httpService.postAndProcessResponse(
        _urlLogin,
        data: SignInRequest(email: email, username: username).toJson(),
        serializer: (data) => SignInResponse.fromJson(data),
      ))
          .getDataOrThrow();
}
