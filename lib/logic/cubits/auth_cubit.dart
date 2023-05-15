// import 'package:enthem2frontend/firebase/sign_in_method.dart';
// import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';

// enum AuthState {
//   signingInitial,
//   signedIn,
//   signingLoading,
//   signinError,
//   userExistsInDB,
//   userNotExistsInDB
// }

// class AuthCubit extends Cubit<AuthState> {
//   final AuthService _authService = AuthService();
//   final UserAPIRepository _userAPIRepository = UserAPIRepository();

//   AuthCubit() : super(AuthState.signingInitial);

//   void signIn() async {
//     try {
//       emit(AuthState.signingLoading);
//       await _authService.signInGoogle();
//       emit(AuthState.signedIn);
//     } catch (err) {
//       emit(AuthState.signinError);
//     }
//   }

//   void handleAuth() async {}

//   void checkUserExists(String uid) async {
//     try {
//       emit(AuthState.signingLoading);
//       final bool isUser = await _userAPIRepository.checkUserExists(uid);
//       if (isUser) {
//         emit(AuthState.userExistsInDB);
//       } else {
//         emit(AuthState.userNotExistsInDB);
//       }
//     } catch (err) {
//       emit(AuthState.signinError);
//     }
//   }
// }
