import 'dart:async';

import 'package:hive/hive.dart';
import 'package:simon_ai/core/common/extension/stream_future_extensions.dart';
import 'package:simon_ai/core/common/result.dart';
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
    _firebaseAuthService.authStateChanges.skip(1).listen((user) {
      if (user == null) {
        logOut();
      }
    });
  }

  Stream<String?> get currentUserEmail =>
      _firebaseAuthService.authStateChanges.map((user) => user?.email);

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

  Future<void> logOut() async {
    await Hive.deleteFromDisk();
    await _firebaseAuthService.signOut();
    await _authLocalSource.saveUserToken(null);
    await _authLocalSource.saveCurrentPlayer(null);
  }
}
