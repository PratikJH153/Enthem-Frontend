import '../../models/user.dart';
import '/logic/repositories/user_api_repository.dart';
import '/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Cubit<UserState> {
  static final _provider = UserAPIRepository();

  UserBloc() : super(UserDataLoadingState()) {
    final String userId = _provider.getUserID();
    fetchUserData(userId);
  }

  Future<void> fetchUserData(String userId) async {
    try {
      final UserModel userData = await _provider.getUser(userId);
      print("User data fetched!${userData.toJson()}");

      emit(UserDataFetchedState(userData));
    } catch (e) {
      emit(UserDataFetchedState(null));
    }
  }
}
