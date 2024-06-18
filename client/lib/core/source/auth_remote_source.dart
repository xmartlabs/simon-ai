import 'package:simon_ai/core/model/service/auth_models.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/source/common/http_service.dart';

class AuthRemoteSource {
  // ignore: unused_field
  final HttpServiceDio _httpService;

  AuthRemoteSource(this._httpService);

  Future<SignInResponse> signIn(String email, String? username) async =>
      SignInResponse(
        accessToken: email,
        user: User(email: email, name: username),
      );
}
