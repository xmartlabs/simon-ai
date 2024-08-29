import 'dart:async';

import 'package:hive/hive.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/common/result.dart';
import 'package:simon_ai/core/model/user.dart';
import 'package:simon_ai/core/services/firebase_auth.dart';
import 'package:simon_ai/core/source/auth_local_source.dart';
import 'package:simon_ai/core/source/auth_remote_source.dart';

class SessionRepository {
  final AuthLocalSource _authLocalSource;
  final AuthRemoteSource _authRemoteSource;
  final FirebaseAuthService _firebaseAuthService;

  SessionRepository(
    this._authLocalSource,
    this._authRemoteSource,
    this._firebaseAuthService,
  ) {
    _firebaseAuthService.authStateChanges.listen((user) {
      if (user == null) {
        logOut();
      }
    });
  }

  Stream<String?> get currentUserEmail =>
      _firebaseAuthService.authStateChanges.map((user) => user?.email);

  Stream<User?> getUserInfo() => _authLocalSource.getUser();

  Future<User?> getUser() => _authLocalSource.getUser().first;

  Future<Result<void>> signInUser({
    required String email,
    required String password,
  }) async {
    final result =
        await _authRemoteSource.signIn(email, password).mapToResult();
    if (result.data != null) {
      await _authLocalSource.saveUserToken(result.data!.user?.uid);
    }
    return result;
  }

  Future<Result<void>> registerPlayer({
    required String email,
    String? username,
  }) async {
    final sessionToken = await _authLocalSource.getUserToken().first;
    return _authLocalSource
        .saveUserInfo(
          User(email: email, name: username, createdBy: sessionToken ?? ''),
        )
        .mapToResult();
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
    await _firebaseAuthService.signOut();
    await _authLocalSource.saveUserToken(null);
    await _authLocalSource.saveUserInfo(null);
  }
}
