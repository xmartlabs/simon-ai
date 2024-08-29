import 'package:firebase_auth/firebase_auth.dart';
import 'package:simon_ai/core/services/firebase_auth.dart';
import 'package:simon_ai/core/source/common/http_service.dart';

class AuthRemoteSource {
  // ignore: unused_field
  final HttpServiceDio _httpService;
  final FirebaseAuthService _firebaseAuth;

  AuthRemoteSource(this._httpService, this._firebaseAuth);

  Future<UserCredential> signIn(String email, String password) =>
      _firebaseAuth.signInWithEmailAndPassword(email, password);
}
