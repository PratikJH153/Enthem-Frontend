import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<User> signInGoogle();
  dynamic getCurrentUserID();
  Future<bool> signOut();
}
