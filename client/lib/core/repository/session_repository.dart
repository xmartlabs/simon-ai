import 'dart:async';

import 'package:hive/hive.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/common/result.dart';
import 'package:simon_ai/core/model/authentication_status.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/auth_remote_source.dart';

class SessionRepository {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;

  SessionRepository(
    this._authLocalSource,
    this._authRemoteSource,
  );

  Stream<AuthenticationStatus> get status =>
      _authLocalSource.getUserToken().map(
            (token) => token == null
                ? AuthenticationStatus.unauthenticated
                : AuthenticationStatus.authenticated,
          );

  Stream<User?> getUserInfo() => _authLocalSource.getUser();

  Future<User?> getUser() => _authLocalSource.getUser().first;

  Future<Result<void>> signInUser({
    required String email,
    String? username,
  }) async {
    final response = await _authRemoteSource.signIn(email, username);
    return _authLocalSource.saveUserInfo(response.user).mapToResult();
  }

  Future<Result<void>> saveUsername(String username) async {
    final user = await _authLocalSource.getUser().first;
    return _authLocalSource
        .saveUserInfo(user!.copyWith(name: username))
        .mapToResult();
  }

  Future<Result<void>> saveEmail(String email) async {
    final user = await _authLocalSource.getUser().first ?? User(email: email);
    return _authLocalSource
        .saveUserInfo(user.copyWith(email: email))
        .mapToResult();
  }

  Future<void> logOut() async {
    await Hive.deleteFromDisk();
    await _authLocalSource.saveUserToken(null);
    await _authLocalSource.saveUserInfo(null);
  }
}
