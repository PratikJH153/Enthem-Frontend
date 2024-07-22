import 'package:enthem2/services/debug_console.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import './sign_in_contract.dart';

class AuthService implements IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String filename = "sign_in_method.dart";

  @override
  Future<User> signInGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw Exception('Google sign-in failed.');
      }

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
      User user = authResult.user!;

      assert(!user.isAnonymous);
      User currentUser = _firebaseAuth.currentUser!;
      assert(user.uid == currentUser.uid);

      debugData("User Name: ${user.displayName} Email: ${user.email}", filename);

      return user;
    } catch (err) {
      debugError('Error: ${err.toString()}\nStackTrace: ${StackTrace.current}', "sign_in_method.dart");
      rethrow;
    }
  }

  @override
  dynamic getCurrentUserID() {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser!.uid;
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      _googleSignIn.signOut();
      _googleSignIn.disconnect();
      _firebaseAuth.signOut();

      return true;
    } catch (err) {
      debugError(err.toString(), "sign_in_method.dart");
      rethrow;
    }
  }
}
