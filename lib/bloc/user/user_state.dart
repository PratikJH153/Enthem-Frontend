import '../../models/user.dart';

abstract class UserState {}

class UserDataLoadingState extends UserState {}

class UserDataFetchedState extends UserState {
  final UserModel? userData;
  UserDataFetchedState(this.userData);
}
