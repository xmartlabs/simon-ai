import 'package:firebase_auth/firebase_auth.dart';
import 'package:simon_ai/core/services/firebase_auth.dart';

class AuthRemoteSource {
  final FirebaseAuthService _firebaseAuth;

  AuthRemoteSource(this._firebaseAuth);

  Future<UserCredential> signIn(String email, String password) =>
      _firebaseAuth.signInWithEmailAndPassword(email, password);
}
